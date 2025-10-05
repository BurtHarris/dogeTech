#!/bin/bash
# Host Requirements Sanity Check - Bash Version

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# Arrays for tracking
MISSING_REQUIRED=()
MISSING_OPTIONAL=()

echo -e "${CYAN}🔍 DogeTech Host Requirements Check${NC}"
echo -e "${CYAN}===================================${NC}"
echo ""

# Helper function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Helper function to get version
get_version() {
    local cmd="$1"
    local arg="${2:---version}"
    if command_exists "$cmd"; then
        $cmd $arg 2>/dev/null | head -n1 || echo "Unknown"
    else
        echo "Not found"
    fi
}

echo -e "${YELLOW}🔧 Checking Required Tools...${NC}"
echo ""

# Check Docker Desktop
echo -n "📦 Docker Desktop... "
if command_exists docker; then
    DOCKER_VERSION=$(get_version docker --version)
    echo -e "${GREEN}✅ Found: $DOCKER_VERSION${NC}"
    
    # Check if Docker daemon is running
    if docker ps >/dev/null 2>&1; then
        echo -e "   ${GREEN}🟢 Docker daemon is running${NC}"
    else
        echo -e "   ${YELLOW}🟡 Docker daemon not running - start Docker Desktop${NC}"
    fi
else
    echo -e "${RED}❌ Missing${NC}"
    MISSING_REQUIRED+=("Docker Desktop|Container runtime for development environment|
macOS: Download from https://www.docker.com/products/docker-desktop/
Linux: Install docker and docker-compose via package manager:
  Ubuntu/Debian: sudo apt install docker.io docker-compose
  CentOS/RHEL: sudo yum install docker docker-compose
  Arch: sudo pacman -S docker docker-compose")
fi

# Check Docker Compose
echo -n "🐳 Docker Compose... "
if command_exists docker-compose; then
    COMPOSE_VERSION=$(get_version docker-compose --version)
    echo -e "${GREEN}✅ Found: $COMPOSE_VERSION${NC}"
elif command_exists docker && docker compose version >/dev/null 2>&1; then
    COMPOSE_VERSION=$(docker compose version)
    echo -e "${GREEN}✅ Found: $COMPOSE_VERSION (plugin)${NC}"
else
    echo -e "${RED}❌ Missing${NC}"
    MISSING_REQUIRED+=("Docker Compose|Multi-container orchestration|
Usually included with Docker Desktop. 
For Linux: sudo apt install docker-compose (Ubuntu/Debian)
           sudo yum install docker-compose (CentOS/RHEL)")
fi

# Check Git
echo -n "📝 Git... "
if command_exists git; then
    GIT_VERSION=$(get_version git --version)
    echo -e "${GREEN}✅ Found: $GIT_VERSION${NC}"
else
    echo -e "${RED}❌ Missing${NC}"
    MISSING_REQUIRED+=("Git|Version control system|
macOS: Install Xcode Command Line Tools: xcode-select --install
       Or via Homebrew: brew install git
Linux: sudo apt install git (Ubuntu/Debian)
       sudo yum install git (CentOS/RHEL)")
fi

# Check PowerShell
echo -n "💻 PowerShell... "
if command_exists pwsh; then
    PWSH_VERSION=$(get_version pwsh --version)
    echo -e "${GREEN}✅ Found: $PWSH_VERSION${NC}"
elif command_exists powershell; then
    PS_VERSION=$(get_version powershell --version)
    echo -e "${GREEN}✅ Found: $PS_VERSION${NC}"
else
    echo -e "${RED}❌ Missing${NC}"
    MISSING_REQUIRED+=("PowerShell 7+|Script execution and container interaction|
macOS: Install via Homebrew: brew install powershell
Linux: Follow instructions at https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux
       Ubuntu: sudo snap install powershell --classic
       Or download from: https://github.com/PowerShell/PowerShell/releases")
fi

echo ""
echo -e "${YELLOW}🔧 Checking Optional Tools...${NC}"
echo ""

# Check Node.js
echo -n "🟢 Node.js... "
if command_exists node; then
    NODE_VERSION=$(get_version node --version)
    echo -e "${GREEN}✅ Found: $NODE_VERSION${NC}"
    
    # Check npm
    echo -n "📦 npm... "
    if command_exists npm; then
        NPM_VERSION=$(get_version npm --version)
        echo -e "${GREEN}✅ Found: v$NPM_VERSION${NC}"
    else
        echo -e "${RED}❌ Missing${NC}"
        MISSING_OPTIONAL+=("npm|Package manager for running convenience scripts|
Usually included with Node.js. Try reinstalling Node.js.")
    fi
else
    echo -e "${RED}❌ Missing${NC}"
    MISSING_OPTIONAL+=("Node.js & npm|JavaScript runtime and package manager for convenience scripts|
macOS: Install via Homebrew: brew install node
       Or download from: https://nodejs.org/
Linux: Install via package manager or NodeSource:
       Ubuntu: curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
               sudo apt-get install -y nodejs
       
Note: You can use Docker Compose directly without Node.js, but npm scripts are more convenient.")
fi

# Check curl
echo -n "🌐 curl... "
if command_exists curl; then
    CURL_VERSION=$(get_version curl --version | head -n1)
    echo -e "${GREEN}✅ Found: $CURL_VERSION${NC}"
else
    echo -e "${RED}❌ Missing${NC}"
    MISSING_OPTIONAL+=("curl|HTTP client for testing API endpoints|
macOS: Usually pre-installed, or: brew install curl
Linux: sudo apt install curl (Ubuntu/Debian)
       sudo yum install curl (CentOS/RHEL)")
fi

# Check VS Code
echo -n "📝 VS Code... "
if command_exists code; then
    echo -e "${GREEN}✅ Found${NC}"
    
    # Check Dev Containers extension
    if code --list-extensions 2>/dev/null | grep -q "ms-vscode-remote.remote-containers"; then
        echo -e "   ${GREEN}✅ Dev Containers extension installed${NC}"
    else
        echo -e "   ${YELLOW}🟡 Dev Containers extension not found${NC}"
        MISSING_OPTIONAL+=("VS Code Dev Containers Extension|Seamless container development experience|
Install via VS Code:
  1. Open VS Code
  2. Go to Extensions (Ctrl+Shift+X)
  3. Search for 'Dev Containers'
  4. Install the extension by Microsoft
  
Or via command line: code --install-extension ms-vscode-remote.remote-containers")
    fi
else
    echo -e "${RED}❌ Missing${NC}"
    MISSING_OPTIONAL+=("VS Code|Integrated development environment with container support|
macOS: Download from https://code.visualstudio.com/
       Or via Homebrew: brew install --cask visual-studio-code
Linux: Download from https://code.visualstudio.com/
       Or install via snap: sudo snap install code --classic")
fi

# Results Summary
echo ""
echo -e "${CYAN}📊 Summary${NC}"
echo -e "${CYAN}==========${NC}"
echo ""

if [ ${#MISSING_REQUIRED[@]} -eq 0 ]; then
    echo -e "${GREEN}🎉 All required tools are installed!${NC}"
    echo -e "${GREEN}   You can run: npm run docker:dev (or docker-compose up app-dev)${NC}"
else
    echo -e "${RED}❌ Missing ${#MISSING_REQUIRED[@]} required tool(s)${NC}"
    echo -e "${RED}   Install missing tools before running DogeTech${NC}"
fi

if [ ${#MISSING_OPTIONAL[@]} -eq 0 ]; then
    echo -e "${GREEN}✨ All optional tools are installed!${NC}"
else
    echo -e "${YELLOW}🟡 Missing ${#MISSING_OPTIONAL[@]} optional tool(s)${NC}"
    echo -e "${YELLOW}   Optional tools improve the development experience${NC}"
fi

# Installation Instructions
if [ ${#MISSING_REQUIRED[@]} -gt 0 ] || [ ${#MISSING_OPTIONAL[@]} -gt 0 ]; then
    echo ""
    echo -e "${CYAN}📋 Installation Instructions${NC}"
    echo -e "${CYAN}============================${NC}"
    echo ""
    
    if [ ${#MISSING_REQUIRED[@]} -gt 0 ]; then
        echo -e "${RED}🚨 REQUIRED TOOLS:${NC}"
        echo ""
        for missing in "${MISSING_REQUIRED[@]}"; do
            IFS='|' read -r tool purpose instructions <<< "$missing"
            echo -e "${RED}▶️  $tool${NC}"
            echo -e "   Purpose: $purpose"
            echo -e "   Installation:"
            echo -e "${GRAY}$instructions${NC}"
            echo ""
        done
    fi
    
    if [ ${#MISSING_OPTIONAL[@]} -gt 0 ]; then
        echo -e "${YELLOW}💡 OPTIONAL TOOLS:${NC}"
        echo ""
        for missing in "${MISSING_OPTIONAL[@]}"; do
            IFS='|' read -r tool purpose instructions <<< "$missing"
            echo -e "${YELLOW}▶️  $tool${NC}"
            echo -e "   Purpose: $purpose"
            echo -e "   Installation:"
            echo -e "${GRAY}$instructions${NC}"
            echo ""
        done
    fi
fi

echo ""
echo -e "${CYAN}🔗 Quick Setup Commands:${NC}"
echo -e "${CYAN}========================${NC}"
echo ""
echo -e "${GREEN}# After installing required tools:${NC}"
echo -e "${GRAY}git clone <your-repo>${NC}"
echo -e "${GRAY}cd dogeTech${NC}"
echo -e "${GRAY}npm run secrets:setup  # Setup GitHub tokens${NC}"
echo -e "${GRAY}npm run docker:dev     # Start development environment${NC}"
echo ""
echo -e "${GREEN}# Alternative without npm:${NC}"
echo -e "${GRAY}docker-compose up app-dev${NC}"

# Exit with appropriate code
if [ ${#MISSING_REQUIRED[@]} -gt 0 ]; then
    exit 1
else
    exit 0
fi