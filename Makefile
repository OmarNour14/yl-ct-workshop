SHELL := /bin/bash
BACKEND_DIR := 01-backend-init
ORG_DIR := 02-aws-organizations
CT_DIR := 03-control-tower
TFVARS := terraform.tfvars

.PHONY: all validate-vars copy-vars init-backend update-backends plan-apply-org plan-apply-ct cleanup

all: validate-vars copy-vars init-backend update-backends plan-apply-org plan-apply-ct cleanup

validate-vars:
	@if [ ! -f $(TFVARS) ]; then \
		echo "❌ terraform.tfvars not found in root directory."; \
		exit 1; \
	fi
	@if ! grep -qE '^security_account_email[[:space:]]*=[[:space:]]*".+@.+\..+"' $(TFVARS); then \
		echo "❌ Missing or invalid 'security_account_email' in terraform.tfvars."; \
		exit 1; \
	fi
	@if ! grep -qE '^logging_account_email[[:space:]]*=[[:space:]]*".+@.+\..+"' $(TFVARS); then \
		echo "❌ Missing or invalid 'logging_account_email' in terraform.tfvars."; \
		exit 1; \
	fi
	@echo "✅ terraform.tfvars validated."

copy-vars:
	cp $(TFVARS) $(ORG_DIR)/
	cp $(TFVARS) $(CT_DIR)/
	@echo "✅ terraform.tfvars copied to module directories."

init-backend:
	cd $(BACKEND_DIR) && terraform init && terraform apply -auto-approve
	@terraform -chdir=$(BACKEND_DIR) output -raw bucket_name > .bucket_name
	@echo "✅ S3 bucket created: $$(cat .bucket_name)"

update-backends:
	@BUCKET_NAME=$$(cat .bucket_name); \
	echo "📦 Using bucket: $$BUCKET_NAME"; \
	sed -i "" "s/{{REPLACE_WITH_S3_BUCKET}}/$$BUCKET_NAME/g" $(ORG_DIR)/backend.tf; \
	sed -i "" "s/{{REPLACE_WITH_S3_BUCKET}}/$$BUCKET_NAME/g" $(CT_DIR)/backend.tf; \
	echo "✅ Updated backend.tf files with backend bucket: $$BUCKET_NAME"

plan-apply-org:
	cd $(ORG_DIR) && terraform init && terraform plan -var-file=terraform.tfvars && terraform apply -var-file=terraform.tfvars -auto-approve
	@echo "✅ Applied Terraform for aws-organizations."

plan-apply-ct:
	cd $(CT_DIR) && terraform init && terraform plan -var-file=terraform.tfvars && terraform apply -var-file=terraform.tfvars -auto-approve
	@echo "✅ Applied Terraform for control-tower."

cleanup:
	@echo "🧹 Running cleanup..."
	# Remove terraform lock files
	rm -f $(ORG_DIR)/.terraform.lock.hcl $(CT_DIR)/.terraform.lock.hcl
	@echo "🗑️  Deleted .terraform.lock.hcl files"

	# Revert backend.tf files to placeholder
	sed -i "" "s/bucket = \".*\"/bucket = \"{{REPLACE_WITH_S3_BUCKET}}\"/g" $(ORG_DIR)/backend.tf
	sed -i "" "s/bucket = \".*\"/bucket = \"{{REPLACE_WITH_S3_BUCKET}}\"/g" $(CT_DIR)/backend.tf
	@echo "🔁 Reverted backend.tf bucket names to '{{REPLACE_WITH_S3_BUCKET}}'"

	@echo "✅ Cleanup completed successfully."
