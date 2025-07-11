SHELL := /bin/bash
BACKEND_DIR := 01-backend-init
ORG_DIR := 02-aws-organizations
CT_DIR := 03-control-tower
TFVARS := terraform.tfvars

.PHONY: all validate-vars copy-vars init-backend update-backends plan-apply-org plan-apply-ct cleanup force-all

# Run all steps and always cleanup at the end
all:
	@$(MAKE) force-all || true; $(MAKE) cleanup

# Main pipeline logic
force-all: validate-vars copy-vars init-backend update-backends plan-apply-org plan-apply-ct

validate-vars:
	@if [ ! -f $(TFVARS) ]; then \
		echo "❌ terraform.tfvars not found in root directory."; \
		exit 1; \
	fi
	@if ! grep -qE '^security_account_email[[:space:]]*=[[:space:]]*".+\+security@proton\.me"' $(TFVARS); then \
		echo "❌ 'security_account_email' must end with +security@proton.me."; \
		exit 1; \
	fi
	@if ! grep -qE '^logging_account_email[[:space:]]*=[[:space:]]*".+\+logging@proton\.me"' $(TFVARS); then \
		echo "❌ 'logging_account_email' must end with +logging@proton.me."; \
		exit 1; \
	fi
	@echo "✅ terraform.tfvars validated: required emails are present and correctly formatted."

copy-vars:
	cp $(TFVARS) $(ORG_DIR)/
	cp $(TFVARS) $(CT_DIR)/
	@echo "✅ terraform.tfvars copied to module directories."

init-backend:
	cd $(BACKEND_DIR) && terraform init -reconfigure && terraform apply -auto-approve
	@terraform -chdir=$(BACKEND_DIR) output -raw bucket_name > .bucket_name
	@echo "✅ S3 bucket created: $$(cat .bucket_name)"

update-backends:
	@BUCKET_NAME=$$(cat .bucket_name); \
	echo "📦 Using bucket: $$BUCKET_NAME"; \
	sed -i "" "s/{{REPLACE_WITH_S3_BUCKET}}/$$BUCKET_NAME/g" $(ORG_DIR)/backend.tf; \
	sed -i "" "s/{{REPLACE_WITH_S3_BUCKET}}/$$BUCKET_NAME/g" $(CT_DIR)/backend.tf; \
	echo "✅ Updated backend.tf files with backend bucket: $$BUCKET_NAME"

plan-apply-org:
	@cd $(ORG_DIR) && terraform init -reconfigure
	@cd $(ORG_DIR) && terraform plan -var-file=terraform.tfvars
	@cd $(ORG_DIR) && \
		terraform apply -var-file=terraform.tfvars -auto-approve || { \
			echo "⚠️ Terraform apply failed. Checking for AlreadyInOrganizationException..."; \
			ERR_MSG=$$(terraform apply -var-file=terraform.tfvars -auto-approve 2>&1 || true); \
			echo "$$ERR_MSG" | grep -q "AlreadyInOrganizationException"; \
			if [ $$? -eq 0 ]; then \
				echo "⚠️ Detected: Already part of an AWS Organization. Attempting import..."; \
				ORG_ID=$$(aws organizations describe-organization --query 'Organization.Id' --output text); \
				terraform import 'module.organization.aws_organizations_organization.org' "$$ORG_ID"; \
				terraform apply -var-file=terraform.tfvars -auto-approve; \
			else \
				echo "$$ERR_MSG"; \
				echo "❌ Terraform apply failed with an unexpected error."; \
				exit 1; \
			fi; \
		}
	@echo "✅ Applied Terraform for aws-organizations."

plan-apply-ct:
	cd $(CT_DIR) && terraform init -reconfigure && terraform plan -var-file=terraform.tfvars && terraform apply -var-file=terraform.tfvars -auto-approve
	@echo "✅ Applied Terraform for control-tower."

cleanup:
	@echo "🧹 Running cleanup..."

	@echo "🧼 Removing terraform state and temporary files..."
	@rm -rf $(BACKEND_DIR)/terraform.tfstate
	@rm -f .bucket_name
	@rm -f terraform.tfvars
	@rm -f $(ORG_DIR)/terraform.tfvars $(CT_DIR)/terraform.tfvars

	@if [ -f .bucket_name ]; then \
		BUCKET_NAME=$$(cat .bucket_name); \
		echo "🔁 Reverting backend.tf bucket names from $$BUCKET_NAME to {{REPLACE_WITH_S3_BUCKET}}..."; \
		sed -i "" "s/$$BUCKET_NAME/{{REPLACE_WITH_S3_BUCKET}}/g" $(ORG_DIR)/backend.tf; \
		sed -i "" "s/$$BUCKET_NAME/{{REPLACE_WITH_S3_BUCKET}}/g" $(CT_DIR)/backend.tf; \
	else \
		echo "⚠️  .bucket_name not found. Skipping backend.tf bucket name revert."; \
	fi

	@echo "🗑️  Cleaning up .terraform and lock files..."
	@rm -f $(ORG_DIR)/.terraform.lock.hcl $(CT_DIR)/.terraform.lock.hcl
	@rm -rf $(ORG_DIR)/.terraform $(CT_DIR)/.terraform

	@echo "✅ Cleanup completed successfully."
