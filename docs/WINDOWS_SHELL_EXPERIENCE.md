# 🪟 Windows Developer Shell Experience

This document describes the enhanced shell experience designed specifically for Windows developers working in the DogeTech containerized development environment.

## 🎯 Problem Solved

As a Windows developer, working in a Unix container can be frustrating when:
- Arrow keys don't work properly for command history
- Familiar commands like `dir`, `cls`, `type` don't exist
- Copy/paste shortcuts behave differently
- Tab completion doesn't work as expected
- Command line editing feels foreign

## 🚀 Enhanced Experience

### PowerShell in Container

The container includes **PowerShell 7.4.6** with a custom profile that provides:

#### Windows-Familiar Commands
```powershell
dir          # Lists directory contents (alias for Get-ChildItem)
cls          # Clears screen (alias for Clear-Host)
type         # Shows file contents (alias for Get-Content)
copy         # Copies files (alias for Copy-Item)
move         # Moves files (alias for Move-Item)
del          # Deletes files (alias for Remove-Item)
md           # Creates directory (alias for New-Item)
```

#### Development Shortcuts
```powershell
build        # Runs npm run build
dev          # Runs npm run dev
test         # Runs npm test
start        # Runs npm start
```

### Enhanced Bash Experience

When using bash, you get:

#### Windows-Style Aliases
```bash
cls          # clear
dir          # ls -la
type         # cat
copy         # cp
move         # mv
del          # rm
md           # mkdir
rd           # rmdir
```

#### PowerShell Access
```bash
ps           # pwsh (start PowerShell)
powershell   # pwsh (start PowerShell)
```

#### Better Key Bindings
- **Arrow Keys**: Navigate command history properly
- **Tab Completion**: Case-insensitive with better matching
- **History**: 10,000 commands with smart deduplication

## 🔧 Quick Access

### Easy PowerShell Entry

**npm script (recommended):**
```powershell
npm run shell
# or specifically
npm run shell:powershell
```

**Direct script:**
```powershell
.\scripts\enter-powershell.ps1
```

**From Linux/macOS:**
```bash
npm run shell:powershell:bash
# or
./scripts/enter-powershell.sh
```

### Traditional Bash Access

```powershell
npm run shell:bash
# or
docker exec -it app-dev bash
```

## 🎨 Visual Experience

When you enter PowerShell in the container, you'll see:

```
🐕 Welcome to DogeTech Development Container!
💡 Tip: Use familiar Windows commands like dir, cls, type, etc.
🚀 Quick dev commands: build, dev, test, start

PS /usr/src/app>
```

## 📋 Available Shells

| Shell | Access Command | Best For |
|-------|----------------|----------|
| **PowerShell** | `npm run shell` | Windows developers (recommended) |
| **Bash** | `npm run shell:bash` | Unix-familiar developers |
| **Zsh** | `docker exec -it app-dev zsh` | Advanced shell features |
| **Fish** | `docker exec -it app-dev fish` | Beginner-friendly with great defaults |

## 🔍 Technical Details

### PowerShell Profile Location
- Container: `/opt/microsoft/powershell/7/profile/Microsoft.PowerShell_profile.ps1`
- Automatically loaded when PowerShell starts

### Bash Configuration
- Global config: `/etc/bash.bashrc.local`
- Readline config: `/etc/inputrc.local`
- Automatically sourced for all users

### History Configuration
- **Bash**: 10,000 commands with smart deduplication
- **PowerShell**: Default PowerShell history behavior
- **Persistent**: History survives container restarts (when using volumes)

## 🛠️ Customization

### Adding Your Own Aliases

**PowerShell** (add to container's profile):
```powershell
# Connect to container and edit
docker exec -it app-dev pwsh
# Edit the profile
nano /opt/microsoft/powershell/7/profile/Microsoft.PowerShell_profile.ps1
```

**Bash** (add to local config):
```bash
# Connect to container
docker exec -it app-dev bash
# Edit the local config
nano /etc/bash.bashrc.local
```

### Host-Side PowerShell Profile

You can also enhance your host PowerShell with container shortcuts by adding to your `$PROFILE`:

```powershell
# Quick container access
function Enter-DogeContainer { npm run shell }
Set-Alias -Name doge -Value Enter-DogeContainer

# Container development shortcuts
function Invoke-DogeBuild { docker exec app-dev npm run build }
function Invoke-DogeTest { docker exec app-dev npm test }
Set-Alias -Name doge-build -Value Invoke-DogeBuild
Set-Alias -Name doge-test -Value Invoke-DogeTest
```

## 🎉 Benefits

✅ **Familiar**: Windows commands work as expected  
✅ **Productive**: Quick development shortcuts  
✅ **Flexible**: Multiple shell options available  
✅ **Consistent**: Same experience across team members  
✅ **Easy**: One command to get started (`npm run shell`)  

This enhanced shell experience bridges the gap between Windows development habits and containerized Unix environments, making you more productive from day one!