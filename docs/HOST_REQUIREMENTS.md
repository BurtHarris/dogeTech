# Host Requirements Check

DogeTech includes a comprehensive host requirements sanity check to validate that all necessary tools are installed on your system before running the development environment.

## 🔍 Quick Check

```bash
# Check all requirements (recommended)
npm run check:requirements

# Cross-platform alternatives
pwsh -File scripts/check-host-requirements.ps1
bash scripts/check-host-requirements.sh
```

## 📋 Required Tools

The following tools **must** be installed on your host system:

| Tool | Purpose | Check |
|------|---------|-------|
| **Docker Desktop** | Container runtime | `docker --version` |
| **Git** | Version control | `git --version` |
| **PowerShell** 5.1+ | Script execution | `pwsh --version` |
| **Docker Compose** | Multi-container orchestration | `docker-compose --version` |

## 🔧 Optional Tools

These tools improve the development experience but aren't required:

| Tool | Purpose | Check |
|------|---------|-------|
| **Node.js & npm** | Package manager for convenience scripts | `node --version` |
| **curl** | HTTP client for testing APIs | `curl --version` |
| **VS Code** | IDE with container support | `code --version` |
| **Dev Containers Extension** | Seamless container development | VS Code extension |

## 🚀 What the Script Checks

### ✅ **Validates Installation**
- Confirms each tool is available in PATH
- Checks version compatibility
- Verifies Docker daemon is running

### 📦 **Provides Installation Guidance**
- Platform-specific installation instructions
- Multiple installation options (package managers, direct downloads)
- Clear explanation of each tool's purpose

### 🎯 **Exit Codes**
- **Exit 0**: All required tools installed
- **Exit 1**: Missing required tools (blocks development)

## 📱 Platform Support

| Platform | PowerShell Script | Bash Script |
|----------|-------------------|-------------|
| **Windows** | ✅ Native | ✅ WSL/Git Bash |
| **macOS** | ✅ PowerShell 7+ | ✅ Native |
| **Linux** | ✅ PowerShell 7+ | ✅ Native |

## 🔧 Example Output

```bash
🔍 DogeTech Host Requirements Check
===================================

🔧 Checking Required Tools...

📦 Docker Desktop... ✅ Found: Docker version 24.0.0
   🟢 Docker daemon is running
🐳 Docker Compose... ✅ Found: Docker Compose version v2.39.4
📝 Git... ✅ Found: git version 2.51.0
💻 PowerShell... ✅ Found: PowerShell 7.5

🔧 Checking Optional Tools...

🟢 Node.js... ✅ Found: v20.19.5
📦 npm... ✅ Found: v10.8.2
🌐 curl... ✅ Found: curl 8.14.1
📝 VS Code... ✅ Found
   ✅ Dev Containers extension installed

📊 Summary
==========

🎉 All required tools are installed!
   You can run: npm run docker:dev
✨ All optional tools are installed!
```

## 🚨 Missing Tools Example

When tools are missing, the script provides detailed installation instructions:

```bash
❌ Missing 2 required tool(s)
   Install missing tools before running DogeTech

🚨 REQUIRED TOOLS:

▶️  Docker Desktop
   Purpose: Container runtime for development environment
   Installation:
Windows: Download from https://www.docker.com/products/docker-desktop/
  1. Visit https://www.docker.com/products/docker-desktop/
  2. Download Docker Desktop for Windows
  3. Run installer and follow setup wizard
  [...]
```

## 💡 Integration with Setup

The requirements check is automatically integrated into the development workflow:

```bash
# Typical setup process
git clone <your-repo>
cd dogeTech
npm run check:requirements  # Validate host tools
npm run secrets:setup       # Setup GitHub tokens
npm run docker:dev          # Start development
```

This ensures a smooth onboarding experience for new developers! 🎯