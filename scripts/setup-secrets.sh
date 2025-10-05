#!/bin/bash

# Docker Secrets Setup Script
# Run this on the host to set up GitHub secrets

echo "🔐 Setting up Docker Secrets for GitHub Integration"
echo "=================================================="

# Create secrets directory if it doesn't exist
if [ ! -d "secrets" ]; then
    mkdir -p secrets
    echo "📁 Created secrets directory"
fi

# Function to create secret file
create_secret() {
    local secret_name=$1
    local secret_file="secrets/${secret_name}.txt"
    local example_file="secrets/${secret_name}.txt.example"
    
    if [ -f "$secret_file" ]; then
        echo "⚠️  $secret_file already exists"
        read -p "Do you want to replace it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return
        fi
    fi
    
    echo "Please enter your $secret_name:"
    read -s token
    echo "$token" > "$secret_file"
    chmod 600 "$secret_file"
    echo "✅ $secret_file created with restricted permissions"
}

echo ""
echo "📝 You'll need to create GitHub tokens at:"
echo "   https://github.com/settings/tokens"
echo ""
echo "Required scopes for the token:"
echo "   - repo (for repository access)"
echo "   - read:user (for user information)"
echo "   - copilot (for GitHub Copilot access)"
echo ""

# Create GitHub token
create_secret "github_token"

echo ""
echo "For GitHub CLI, you can usually use the same token:"
read -p "Use the same token for GitHub CLI? (Y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    create_secret "gh_token"
else
    if [ -f "secrets/github_token.txt" ]; then
        cp "secrets/github_token.txt" "secrets/gh_token.txt"
        chmod 600 "secrets/gh_token.txt"
        echo "✅ GitHub CLI token set to same value"
    fi
fi

echo ""
echo "🎉 Docker secrets setup complete!"
echo ""
echo "💡 Next steps:"
echo "   1. Start your container: npm run docker:dev"
echo "   2. Setup GitHub tools: npm run github:setup"
echo "   3. The secrets will be available at /run/secrets/ in the container"