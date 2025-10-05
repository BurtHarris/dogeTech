#!/bin/bash

# GitHub Tools Installation and Setup Script
# Run this inside the container to install and authenticate with GitHub tools

echo "🐕 DogeTech Dev Environment - GitHub Tools Setup"
echo "================================================"

# Check for Docker secrets
if [ -f "/run/secrets/github_token" ]; then
    export GITHUB_TOKEN=$(cat /run/secrets/github_token)
    echo "✅ GitHub token loaded from Docker secret"
fi

if [ -f "/run/secrets/gh_token" ]; then
    export GH_TOKEN=$(cat /run/secrets/gh_token)
    echo "✅ GitHub CLI token loaded from Docker secret"
fi

# Install GitHub CLI
echo "📦 Installing GitHub CLI..."
if ! command -v gh &> /dev/null; then
    # Get the latest release URL dynamically
    GH_VERSION=$(curl -s https://api.github.com/repos/cli/cli/releases/latest | grep '"tag_name"' | cut -d'"' -f4 | sed 's/v//')
    curl -fsSL "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz" | tar -xz -C /tmp
    mv "/tmp/gh_${GH_VERSION}_linux_amd64/bin/gh" /usr/local/bin/
    rm -rf /tmp/gh_*
    echo "✅ GitHub CLI installed"
else
    echo "✅ GitHub CLI already installed"
fi

# Install GitHub Copilot CLI
echo "🤖 Installing GitHub Copilot CLI..."
if ! command -v github-copilot-cli &> /dev/null; then
    npm install -g @githubnext/github-copilot-cli --no-audit --no-fund
    echo "✅ GitHub Copilot CLI installed"
else
    echo "✅ GitHub Copilot CLI already installed"
fi

# Setup aliases
echo "📝 Setting up convenient aliases..."
cat >> ~/.bashrc << 'EOF'

# GitHub Copilot CLI aliases
alias copilot="github-copilot-cli"
alias gh-copilot="github-copilot-cli"
alias ghcs="github-copilot-cli suggest"
EOF

echo "✅ Aliases added to ~/.bashrc"
echo ""

# GitHub CLI authentication
echo "🔐 Setting up GitHub CLI authentication..."
echo "Run: gh auth login"
echo "Choose 'GitHub.com' and follow the prompts"
echo ""

# GitHub Copilot CLI setup
echo "🤖 Setting up GitHub Copilot CLI..."
echo "After GitHub CLI auth, run: github-copilot-cli auth"
echo ""

echo "🎉 Installation complete! Reload your shell or run: source ~/.bashrc"
echo ""
echo "💡 Quick commands:"
echo "  - gh auth login                    # Authenticate with GitHub"
echo "  - github-copilot-cli auth          # Authenticate Copilot CLI"
echo "  - copilot suggest 'command help'   # Get command suggestions"
echo "  - github-copilot-cli what-the-shell 'explain command' # Explain shell commands"
echo "  - github-copilot-cli git-assist    # Git command help"