#!/bin/bash

# Function to install GitHub CLI (gh)
install_gh() {
  echo "📦 Installing GitHub CLI (gh)..."

  if [ "$(uname)" == "Darwin" ]; then
    # macOS
    if ! command -v brew &> /dev/null; then
      echo "❌ Homebrew not found. Please install Homebrew first: https://brew.sh/"
      exit 1
    fi
    brew install gh

  elif [ -f "/etc/debian_version" ]; then
    # Debian/Ubuntu
    sudo apt update
    sudo apt install -y gh

  elif [ -f "/etc/redhat-release" ]; then
    # RHEL, CentOS, Amazon Linux
    sudo yum install -y gh

  else
    echo "❌ Unsupported OS. Please install GitHub CLI manually: https://cli.github.com/"
    exit 1
  fi
}

# Ensure GitHub CLI is installed
if ! command -v gh &> /dev/null; then
  install_gh
else
  echo "✅ GitHub CLI is already installed"
fi

# Authenticate with GitHub if not already
if ! gh auth status &>/dev/null; then
  echo "🔐 Logging into GitHub..."
  gh auth login
fi

# Get authenticated GitHub username
GH_USER=$(gh api user --jq .login)
echo "✅ Authenticated as $GH_USER"

# Git config check
if [ -z "$(git config --global user.name)" ]; then
  read -p "👤 Enter your GitHub name: " name
  git config --global user.name "$name"
fi

if [ -z "$(git config --global user.email)" ]; then
  read -p "📧 Enter your GitHub email: " email
  git config --global user.email "$email"
fi

# Folder setup
SOURCE_BASE="./aft-repos"
DEST_BASE=~/Desktop
FOLDERS=(
  "aft-account-customizations"
  "aft-account-provisioning-customizations"
  "aft-account-request"
  "aft-global-customizations"
)

for folder in "${FOLDERS[@]}"; do
  src="$SOURCE_BASE/$folder"
  dest="$DEST_BASE/$folder"

  echo "📁 Copying $src to $dest"
  cp -r "$src" "$dest"

    cd "$dest" || { echo "❌ Failed to cd into $dest"; exit 1; }

    echo "🔧 Initializing Git repo in $dest"
    git init
    git add .
    git commit -m "Initial commit"
    git branch -M main

    echo "🌐 Creating public GitHub repo: $GH_USER/$folder"
    gh repo create "$GH_USER/$folder" --public --source=. --remote=origin --push

    echo "🚀 Successfully pushed $folder to https://github.com/$GH_USER/$folder"
    echo "-----------------------------"

    cd - > /dev/null
done
