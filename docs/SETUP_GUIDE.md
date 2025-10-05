# 🚀 DogeTech Experimental Dev Environment Setup

## Overview
This is a **safe, isolated development environment** for GitHub Copilot experiments using VS Code's Dev Containers extension. Your code stays on Windows, but runs in a Ubuntu container with Node.js, TypeScript, and PowerShell.

## ✅ Prerequisites

### Required Software
1. **Docker Desktop** - [Download here](https://www.docker.com/products/docker-desktop/)
2. **VS Code** - [Download here](https://code.visualstudio.com/)
3. **Dev Containers Extension** - Install from VS Code Extensions marketplace

### System Requirements
- Windows 10/11 with WSL2 enabled
- At least 8GB RAM (16GB recommended)
- 10GB free disk space

## 🛠️ Quick Setup (5 minutes)

### 1. Clone and Open
```powershell
git clone https://github.com/yourusername/dogeTech.git
cd dogeTech
code .
```

### 2. Install Dev Containers Extension
- Open VS Code Command Palette (`Ctrl+Shift+P`)
- Type: "Extensions: Install Extensions"
- Search for "Dev Containers" by Microsoft
- Click Install

### 3. Open in Container
- VS Code should show a popup: "Reopen in Container"
- Click "Reopen in Container"
- **OR** use Command Palette: "Dev Containers: Reopen in Container"

### 4. Wait for Setup
- First time takes 5-10 minutes (downloads and builds container)
- VS Code will automatically:
  - Build the container
  - Install dependencies
  - Configure the environment
  - Open a PowerShell terminal inside the container

## 🎯 How It Works

### What Happens
- **Your Files**: Stay on Windows, editable in VS Code normally
- **Runtime Environment**: Ubuntu container with Node.js, TypeScript, PowerShell
- **VS Code**: Automatically connects to container, IntelliSense works perfectly
- **Terminal**: Opens PowerShell inside container (all commands run safely isolated)

### File Locations
- **Windows Host**: `D:\dogeTech\` (where you edit)
- **Container**: `/usr/src/app/` (where code runs)
- **Bind Mount**: Files are synchronized automatically

## 💻 Daily Usage

### Starting Development
1. Open VS Code in the dogeTech folder
2. VS Code asks "Reopen in Container" → Click Yes
3. Wait for container to start (fast after first time)
4. Open terminal (`Ctrl+Shift+`` ` ) → You're in PowerShell inside container

### Running Commands
All development commands run **inside the container**:
```powershell
# Install packages
npm install express

# Start development server  
npm run dev

# Run TypeScript compiler
npm run build

# Any Node.js command works safely
node --version
```

### Editing Files
- Edit files normally in VS Code on Windows
- Changes appear instantly in container
- IntelliSense, debugging, extensions all work
- GitHub Copilot is pre-configured and ready

## 🔧 Customization

### Adding New Tools
Edit `dockerfile` to add languages/tools:
```dockerfile
# Add Python
RUN apt-get update && apt-get install -y python3 python3-pip

# Add any other tools
RUN npm install -g @sveltejs/kit
```

### VS Code Extensions  
Edit `.devcontainer/devcontainer.json`:
```json
"extensions": [
  "GitHub.copilot",
  "ms-python.python",  // Add Python support
  "your-extension-here"
]
```

## 🚨 Troubleshooting

### Container Won't Start
```powershell
# Rebuild container
docker-compose build app-dev --no-cache
```

### VS Code Can't Connect
1. Close VS Code
2. Stop containers: `docker-compose down`
3. Restart Docker Desktop
4. Open VS Code, try again

### Files Not Syncing
- Check that you opened VS Code in the `dogeTech` folder
- Verify bind mount in `docker-compose.yml`

## 🎯 What You Get

### Safe Experimentation
- ✅ Container isolation protects Windows host
- ✅ Easy to reset/rebuild if something breaks
- ✅ Consistent environment across machines

### Familiar Development  
- ✅ VS Code works exactly like normal
- ✅ PowerShell terminal (Windows-friendly)
- ✅ All files stay on Windows filesystem

### GitHub Copilot Ready
- ✅ Pre-configured for AI-assisted coding
- ✅ Safe to experiment with generated code
- ✅ Easy to add new languages/frameworks

## 📋 Replication for Apprentice

Send your apprentice this file! The setup is identical:
1. Install Docker Desktop + VS Code + Dev Containers extension
2. Clone the repository
3. Open in VS Code → "Reopen in Container"
4. Identical environment automatically created

## 🚀 Next Steps

Once this is working, you can easily:
- Add Python support for data science experiments
- Add SvelteKit for web development
- Experiment with any new tools safely
- Share exact environment with team members

The container is your playground - break things, try new tools, experiment freely!