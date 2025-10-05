# 🚀 DogeTech: Dev Containers for Windows Developers

**Harness the power of VS Code Dev Containers on Windows! A safe, isolated Node.js/TypeScript environment for GitHub Copilot experiments.**

> 🎯 **For Windows Developers**: Experience the magic of containerized development without leaving your familiar Windows + VS Code workflow. Edit files on Windows, run code in Linux containers - get the best of both worlds!

## 💻 Why Dev Containers + Windows?

**The Problem**: Installing development tools directly on Windows can be messy, version conflicts arise, and experimental tools can clutter your system.

**The Solution**: Dev Containers let you run a complete Linux development environment inside Docker while keeping your familiar Windows editing experience in VS Code.

### 🌟 **Perfect for Windows Developers Who Want To:**
- ✅ **Experiment safely** - Try new tools without cluttering Windows
- ✅ **Avoid "dependency hell"** - Each project gets its own isolated environment  
- ✅ **Keep familiar workflow** - Edit in VS Code on Windows, run in Linux container
- ✅ **Share identical setups** - No more "works on my machine" problems
- ✅ **Use GitHub Copilot effectively** - Pre-configured AI development environmentogeTech Experimental Dev Environment

**A safe, isolated development environment for GitHub Copilot experiments using VS Code Dev Containers.**

> 🎯 **Purpose**: Containerized Node.js/TypeScript environment that protects your host machine while providing a consistent, AI-enhanced development experience. Perfect for experimenting with new tools, learning, and rapid prototyping.

## ⚡ Quick Start (5 minutes)

### Prerequisites (Windows 10/11)
- [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/) with WSL2 backend
- [VS Code](https://code.visualstudio.com/) (the editor you already love!)
- [Dev Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) (Microsoft's official extension)

### Setup
1. **Clone with PowerShell/Command Prompt**:
   ```powershell
   git clone https://github.com/BurtHarris/dogeTech.git
   cd dogeTech
   code .
   ```

2. **Let VS Code do the magic**:
   - VS Code detects the Dev Container config → "Reopen in Container" 
   - Click it and watch Docker + VS Code create your Linux development environment!
   - **OR** manually: `Ctrl+Shift+P` → "Dev Containers: Reopen in Container"

3. **Enjoy the best of both worlds**:
   - **Edit files**: Normal VS Code experience on Windows
   - **Run commands**: PowerShell terminal inside Ubuntu Linux container  
   - **Debug & IntelliSense**: Works seamlessly across the boundary
   - **GitHub Copilot**: Pre-configured and ready for AI-assisted coding

## 🎯 What You Get (Windows Developer Benefits)

- ✅ **Safe Isolation**: Linux container protects your Windows system
- ✅ **Familiar VS Code**: Same editor, same extensions, same shortcuts  
- ✅ **PowerShell in Linux**: Windows-friendly terminal inside Ubuntu container
- ✅ **No Windows PATH pollution**: Tools stay in container, Windows stays clean
- ✅ **GitHub Copilot**: Pre-configured for AI-enhanced development
- ✅ **Hot Reload**: Edit on Windows, see changes instantly in container
- ✅ **Cross-platform consistency**: Same Linux environment on any Windows machine
- ✅ **Easy cleanup**: Delete container to remove all traces

## 🔥 **The Windows Dev Container Advantage**

### Traditional Windows Development Problems:
```
❌ Installing Node.js, Python, databases clutters system PATH
❌ Version conflicts between projects (Node 14 vs Node 20)  
❌ Experimental tools leave traces even after uninstall
❌ "Works on my machine" - different setups across team
❌ Fear of breaking system when trying new tools
```

### With Dev Containers on Windows:
```
✅ Each project gets isolated Linux environment
✅ Switch between Node versions instantly (different containers)
✅ Experiment fearlessly - delete container to reset completely  
✅ Identical team environments - share container configuration
✅ Keep Windows clean - all dev tools contained
```

### Real Example:
```powershell
# Want to try Python data science? No problem!
# Add to Dockerfile: RUN pip install pandas jupyter tensorflow
# Rebuild container - Python tools available instantly
# Delete container later - zero traces on Windows
```

**Result**: Professional Linux-based development workflow while staying in your comfortable Windows environment!

## 🤝 Sharing with Your Team

### For Your Apprentice
1. **Push this repository to GitHub**
2. **Share the repository URL** 
3. **She follows [APPRENTICE_SETUP.md](APPRENTICE_SETUP.md)**
4. **Identical environment automatically created**

### Collaboration Workflow
```powershell
# You make improvements:
git add . && git commit -m "Added Python support" && git push

# She gets updates:
git pull
# In VS Code: Ctrl+Shift+P → "Dev Containers: Rebuild Container"
```

**Result**: Both of you have identical experimental environments that stay in sync!

### Essential Commands

```bash
# Install dependencies (run once)
npm install

# Setup GitHub secrets (secure token storage)
npm run secrets:setup

# Start development environment with hot reload
npm run docker:dev

# Start production environment
npm run docker:prod

# Get interactive shell access to running container
npm run docker:shell

# Setup GitHub CLI and Copilot CLI authentication
npm run github:setup

# Rebuild Docker containers (after Dockerfile changes)
npm run docker:build

# Build TypeScript locally
npm run build

# Stop all containers
docker-compose down
```

### Testing & Validation

```bash
# Quick test - Core functionality (no secrets required)
npm run test:quick

# Full smoke test - Complete integration test with secrets
npm run test:smoke

# Smoke test (Linux/Mac)
npm run test:smoke:bash
```

## What's Included

This dockerized development environment provides:

- 🔄 **Hot Reload**: Automatic restart on file changes with `ts-node-dev`
- 🐛 **Remote Debugging**: Debug port exposed on `9229` for VS Code
- 🤖 **GitHub Copilot CLI**: Pre-installed with command suggestions and explanations
- � **VS Code Integration**: Dev Containers support with extensions pre-configured
- �📦 **Multi-stage Builds**: Separate optimized development and production containers
- 🛠️ **Development Tools**: Git, GitHub CLI, vim, nano, htop, curl pre-installed
- 🔍 **Full TypeScript Support**: Configured with proper types and compilation
- 🐳 **Docker Compose**: Easy container orchestration for dev/prod environments
- 📁 **Volume Mounting**: Live code editing without container rebuilds
- 🌐 **API Ready**: Sample HTTP server listening on port 3000

## Container Specifications

### Development Container (`app-dev`)
- **Base**: Node.js 20 LTS (slim)
- **Tools**: Git, GitHub CLI, vim, nano, htop, curl, procps
- **AI**: GitHub Copilot CLI with command suggestions
- **TypeScript**: Hot reload with `ts-node-dev`
- **Debugging**: Port 9229 exposed for remote debugging
- **Volumes**: Live code mounting with `node_modules` isolation, SSH keys, GitHub config
- **Environment**: `NODE_ENV=development`

### Production Container (`app-prod`)
- **Base**: Node.js 20 LTS (slim) 
- **Optimized**: Multi-stage build with only production dependencies
- **Compiled**: Pre-built TypeScript to JavaScript
- **Environment**: `NODE_ENV=production`

## Debugging with VS Code

1. Start development container: `npm run docker:dev`
2. In VS Code, go to Run & Debug (Ctrl+Shift+D)
3. Create launch configuration:
   ```json
   {
     "type": "node",
     "request": "attach",
     "name": "Docker Debug",
     "port": 9229,
     "restart": true,
     "remoteRoot": "/usr/src/app"
   }
   ```
4. Set breakpoints and start debugging!

## GitHub Copilot CLI Setup

The container comes with GitHub Copilot CLI for AI-powered command assistance, with secure secret management.

### Quick Setup (Recommended)
1. **Setup secrets**: `npm run secrets:setup` (creates secure token files)
2. **Start container**: `npm run docker:dev`
3. **Run setup script**: `npm run github:setup`
4. **Authenticate**: Follow prompts to complete GitHub authentication

### Manual Setup
```bash
# Get shell access
npm run docker:shell

# Authenticate GitHub CLI
gh auth login

# Authenticate Copilot CLI
github-copilot-cli auth
```

### Usage Examples
```bash
# Get command suggestions
github-copilot-cli suggest "find all typescript files"

# Explain a command
github-copilot-cli what-the-shell "find . -name '*.ts' -type f"

# Git assistance
github-copilot-cli git-assist "commit all changes with message"

# Short aliases (available after setup)
copilot suggest "deploy to production"
?? "what does this command do: docker ps -a"
git? "create a new branch"
```

## Configuration

### Environment Variables
- `NODE_ENV`: `development` or `production`
- `PORT`: Application port (default: 3000)
- `DEBUG`: Debug namespaces for enhanced logging

### Docker Secrets (Secure Token Storage)
GitHub tokens are stored as Docker secrets for enhanced security:

```bash
# Setup secrets interactively (Windows)
npm run secrets:setup

# Setup secrets interactively (Linux/Mac)
npm run secrets:setup:bash

# Manual setup
echo "your_token_here" > secrets/github_token.txt
echo "your_token_here" > secrets/gh_token.txt
chmod 600 secrets/*.txt
```

**Security Benefits over .env files:**
- ✅ Tokens stored as files, not environment variables
- ✅ Mounted as temporary filesystems (tmpfs)
- ✅ Never exposed in `docker inspect` or process lists
- ✅ Automatic cleanup when container stops
- ✅ Restricted file permissions (600)
- ✅ Not visible in container environment variables
- ✅ Harder to accidentally leak in logs or dumps

**Access inside container:**
```bash
# Secrets are available at /run/secrets/
cat /run/secrets/github_token
cat /run/secrets/gh_token
```

## Testing & Validation

The environment includes comprehensive automated tests to validate functionality:

### Quick Test (`npm run test:quick`)
- ✅ Container builds successfully
- ✅ API server starts and responds
- ✅ TypeScript compilation works
- ✅ Basic shell functionality
- ⏱️ **Duration**: ~2-3 minutes
- 🔓 **No secrets required**

### Smoke Test (`npm run test:smoke`)
- ✅ All Quick Test validations
- ✅ Docker secrets mounting and accessibility
- ✅ GitHub token security validation
- ✅ Container tools availability (git, curl, vim, etc.)
- ✅ Node.js version verification
- ✅ Development environment integration
- ⏱️ **Duration**: ~3-4 minutes
- 🔐 **Creates test secrets automatically**

Both tests include automatic cleanup and detailed pass/fail reporting.

### Ports
- **3000**: Application HTTP server
- **9229**: Node.js debug/inspector port

## Project Structure

```
dogetech-dev-env/
├── .devcontainer/
│   └── devcontainer.json           # VS Code Dev Container configuration
├── scripts/
│   ├── github-setup.sh             # GitHub CLI and Copilot setup script
│   ├── setup-secrets.sh            # Docker secrets setup (Linux/Mac)
│   ├── setup-secrets.ps1           # Docker secrets setup (Windows)
│   ├── smoke-test.sh               # Comprehensive integration test (Linux/Mac)
│   ├── smoke-test.ps1              # Comprehensive integration test (Windows)
│   └── quick-test.ps1              # Quick functionality test
├── secrets/                        # Docker secrets directory
│   ├── README.md                   # Secrets documentation
│   ├── github_token.txt.example    # Token template
│   └── gh_token.txt.example        # GitHub CLI token template
├── src/
│   └── index.ts                    # Sample TypeScript application
├── dist/                           # Compiled JavaScript output
├── node_modules/                   # Dependencies (gitignored)
├── .env.example                    # Environment variables template
├── .gitignore                      # Comprehensive ignore rules
├── docker-compose.yml              # Container orchestration with secrets
├── dockerfile                      # Multi-stage container definition  
├── package.json                    # Dependencies and scripts
├── tsconfig.json                   # TypeScript configuration
├── docker-compose.override.example.yml  # Local development overrides
└── README.md                       # This file
```

## Getting Started

1. **Clone or download this repository**
2. **Install dependencies**: `npm install`
3. **Start development**: `npm run docker:dev`
4. **Access your app**: Visit `http://localhost:3000`
5. **Start coding**: Edit files in `src/` and watch them reload automatically!

## Use Cases

Perfect for:
- ✅ **Team Development**: Consistent environment across all developers
- ✅ **CI/CD Pipelines**: Reproducible builds and deployments  
- ✅ **Learning Docker**: Complete example with best practices
- ✅ **Microservices**: Template for containerized Node.js services
- ✅ **Remote Development**: Works great with VS Code Remote-Containers

---

**Built with ❤️ for developers who want a hassle-free Docker development experience.**