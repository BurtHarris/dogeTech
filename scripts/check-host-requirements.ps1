#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Host Requirements Sanity Check - PowerShell Version
.DESCRIPTION
    Validates all required host tools for DogeTech development environment
    and provides installation suggestions for missing tools.
.PARAMETER Verbose
    Show detailed information during checks
#>

param(
    [switch]$Verbose
)

Write-Host "🔍 DogeTech Host Requirements Check" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""

$MissingRequired = @()
$MissingOptional = @()

# Helper function to check if command exists
function Test-Command {
    param([string]$Command)
    try {
        $null = Get-Command $Command -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

# Helper function to get version safely
function Get-ToolVersion {
    param([string]$Command, [string]$VersionArg = "--version")
    try {
        $version = & $Command $VersionArg 2>$null | Select-Object -First 1
        return $version
    } catch {
        return "Unknown"
    }
}

Write-Host "🔧 Checking Required Tools..." -ForegroundColor Yellow
Write-Host ""

# Check Docker Desktop
Write-Host "📦 Docker Desktop... " -NoNewline
if (Test-Command "docker") {
    $dockerVersion = Get-ToolVersion "docker" "--version"
    Write-Host "✅ Found: $dockerVersion" -ForegroundColor Green
    
    # Check if Docker daemon is running
    try {
        docker ps > $null 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   🟢 Docker daemon is running" -ForegroundColor Green
        } else {
            Write-Host "   🟡 Docker daemon not running - start Docker Desktop" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "   🟡 Docker daemon not running - start Docker Desktop" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ Missing" -ForegroundColor Red
    $MissingRequired += @{
        Tool = "Docker Desktop"
        Purpose = "Container runtime for development environment"
        InstallInstructions = @"
Windows: Download from https://www.docker.com/products/docker-desktop/
  1. Visit https://www.docker.com/products/docker-desktop/
  2. Download Docker Desktop for Windows
  3. Run installer and follow setup wizard
  4. Restart computer if prompted
  5. Launch Docker Desktop and complete setup
"@
    }
}

# Check Docker Compose
Write-Host "🐳 Docker Compose... " -NoNewline
if (Test-Command "docker-compose") {
    $composeVersion = Get-ToolVersion "docker-compose" "--version"
    Write-Host "✅ Found: $composeVersion" -ForegroundColor Green
} elseif (Test-Command "docker") {
    # Check for docker compose plugin
    try {
        docker compose version > $null 2>&1
        if ($LASTEXITCODE -eq 0) {
            $composeVersion = docker compose version
            Write-Host "✅ Found: $composeVersion (plugin)" -ForegroundColor Green
        } else {
            Write-Host "❌ Missing" -ForegroundColor Red
            $MissingRequired += @{
                Tool = "Docker Compose"
                Purpose = "Multi-container orchestration"
                InstallInstructions = "Usually included with Docker Desktop. Try updating Docker Desktop."
            }
        }
    } catch {
        Write-Host "❌ Missing" -ForegroundColor Red
        $MissingRequired += @{
            Tool = "Docker Compose"
            Purpose = "Multi-container orchestration"
            InstallInstructions = "Usually included with Docker Desktop. Try updating Docker Desktop."
        }
    }
} else {
    Write-Host "❌ Missing (Docker required first)" -ForegroundColor Red
}

# Check Git
Write-Host "📝 Git... " -NoNewline
if (Test-Command "git") {
    $gitVersion = Get-ToolVersion "git" "--version"
    Write-Host "✅ Found: $gitVersion" -ForegroundColor Green
} else {
    Write-Host "❌ Missing" -ForegroundColor Red
    $MissingRequired += @{
        Tool = "Git"
        Purpose = "Version control system"
        InstallInstructions = @"
Windows: 
  Option 1: Download from https://git-scm.com/download/windows
  Option 2: Install via winget: winget install Git.Git
  Option 3: Install via Chocolatey: choco install git
"@
    }
}

# Check PowerShell
Write-Host "💻 PowerShell... " -NoNewline
$psVersion = $PSVersionTable.PSVersion
if ($psVersion.Major -ge 5) {
    Write-Host "✅ Found: PowerShell $($psVersion.Major).$($psVersion.Minor)" -ForegroundColor Green
    if ($psVersion.Major -lt 7) {
        Write-Host "   🟡 Consider upgrading to PowerShell 7+ for better cross-platform support" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ Insufficient version" -ForegroundColor Red
    $MissingRequired += @{
        Tool = "PowerShell 5.1+"
        Purpose = "Script execution and container interaction"
        InstallInstructions = @"
Windows: PowerShell 5.1 should be included with Windows 10+
For PowerShell 7+: 
  1. Download from https://github.com/PowerShell/PowerShell/releases
  2. Or install via winget: winget install Microsoft.PowerShell
"@
    }
}

Write-Host ""
Write-Host "🔧 Checking Optional Tools..." -ForegroundColor Yellow
Write-Host ""

# Check Node.js
Write-Host "🟢 Node.js... " -NoNewline
if (Test-Command "node") {
    $nodeVersion = Get-ToolVersion "node" "--version"
    Write-Host "✅ Found: $nodeVersion" -ForegroundColor Green
    
    # Check npm
    Write-Host "📦 npm... " -NoNewline
    if (Test-Command "npm") {
        $npmVersion = Get-ToolVersion "npm" "--version"
        Write-Host "✅ Found: v$npmVersion" -ForegroundColor Green
    } else {
        Write-Host "❌ Missing" -ForegroundColor Red
        $MissingOptional += @{
            Tool = "npm"
            Purpose = "Package manager for running convenience scripts"
            InstallInstructions = "Usually included with Node.js. Try reinstalling Node.js."
        }
    }
} else {
    Write-Host "❌ Missing" -ForegroundColor Red
    $MissingOptional += @{
        Tool = "Node.js & npm"
        Purpose = "JavaScript runtime and package manager for convenience scripts"
        InstallInstructions = @"
Windows:
  Option 1: Download from https://nodejs.org/ (choose LTS version)
  Option 2: Install via winget: winget install OpenJS.NodeJS
  Option 3: Install via Chocolatey: choco install nodejs
  
Note: You can use Docker Compose directly without Node.js, but npm scripts are more convenient.
"@
    }
}

# Check curl
Write-Host "🌐 curl... " -NoNewline
if (Test-Command "curl") {
    $curlVersion = Get-ToolVersion "curl" "--version" | Select-Object -First 1
    Write-Host "✅ Found: $curlVersion" -ForegroundColor Green
} else {
    Write-Host "❌ Missing" -ForegroundColor Red
    $MissingOptional += @{
        Tool = "curl"
        Purpose = "HTTP client for testing API endpoints"
        InstallInstructions = @"
Windows: Usually included with Windows 10+ 
If missing:
  Option 1: Install via winget: winget install cURL.cURL
  Option 2: Install via Chocolatey: choco install curl
"@
    }
}

# Check VS Code
Write-Host "📝 VS Code... " -NoNewline
if (Test-Command "code") {
    Write-Host "✅ Found" -ForegroundColor Green
    
    # Check Dev Containers extension
    try {
        $extensions = code --list-extensions 2>$null
        if ($extensions -contains "ms-vscode-remote.remote-containers") {
            Write-Host "   ✅ Dev Containers extension installed" -ForegroundColor Green
        } else {
            Write-Host "   🟡 Dev Containers extension not found" -ForegroundColor Yellow
            $MissingOptional += @{
                Tool = "VS Code Dev Containers Extension"
                Purpose = "Seamless container development experience"
                InstallInstructions = @"
Install via VS Code:
  1. Open VS Code
  2. Go to Extensions (Ctrl+Shift+X)
  3. Search for "Dev Containers"
  4. Install the extension by Microsoft
  
Or via command line: code --install-extension ms-vscode-remote.remote-containers
"@
            }
        }
    } catch {
        Write-Host "   🟡 Could not check extensions" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ Missing" -ForegroundColor Red
    $MissingOptional += @{
        Tool = "VS Code"
        Purpose = "Integrated development environment with container support"
        InstallInstructions = @"
Windows:
  Option 1: Download from https://code.visualstudio.com/
  Option 2: Install via winget: winget install Microsoft.VisualStudioCode
  Option 3: Install via Chocolatey: choco install vscode
"@
    }
}

# Results Summary
Write-Host ""
Write-Host "📊 Summary" -ForegroundColor Cyan
Write-Host "==========" -ForegroundColor Cyan
Write-Host ""

if ($MissingRequired.Count -eq 0) {
    Write-Host "🎉 All required tools are installed!" -ForegroundColor Green
    Write-Host "   You can run: npm run docker:dev (or docker-compose up app-dev)" -ForegroundColor Green
} else {
    Write-Host "❌ Missing $($MissingRequired.Count) required tool(s)" -ForegroundColor Red
    Write-Host "   Install missing tools before running DogeTech" -ForegroundColor Red
}

if ($MissingOptional.Count -eq 0) {
    Write-Host "✨ All optional tools are installed!" -ForegroundColor Green
} else {
    Write-Host "🟡 Missing $($MissingOptional.Count) optional tool(s)" -ForegroundColor Yellow
    Write-Host "   Optional tools improve the development experience" -ForegroundColor Yellow
}

# Installation Instructions
if ($MissingRequired.Count -gt 0 -or $MissingOptional.Count -gt 0) {
    Write-Host ""
    Write-Host "📋 Installation Instructions" -ForegroundColor Cyan
    Write-Host "============================" -ForegroundColor Cyan
    Write-Host ""
    
    if ($MissingRequired.Count -gt 0) {
        Write-Host "🚨 REQUIRED TOOLS:" -ForegroundColor Red
        Write-Host ""
        foreach ($missing in $MissingRequired) {
            Write-Host "▶️  $($missing.Tool)" -ForegroundColor Red
            Write-Host "   Purpose: $($missing.Purpose)" -ForegroundColor White
            Write-Host "   Installation:" -ForegroundColor White
            Write-Host "$($missing.InstallInstructions)" -ForegroundColor Gray
            Write-Host ""
        }
    }
    
    if ($MissingOptional.Count -gt 0) {
        Write-Host "💡 OPTIONAL TOOLS:" -ForegroundColor Yellow
        Write-Host ""
        foreach ($missing in $MissingOptional) {
            Write-Host "▶️  $($missing.Tool)" -ForegroundColor Yellow
            Write-Host "   Purpose: $($missing.Purpose)" -ForegroundColor White
            Write-Host "   Installation:" -ForegroundColor White
            Write-Host "$($missing.InstallInstructions)" -ForegroundColor Gray
            Write-Host ""
        }
    }
}

Write-Host ""
Write-Host "🔗 Quick Setup Commands:" -ForegroundColor Cyan
Write-Host "========================" -ForegroundColor Cyan
Write-Host ""
Write-Host "# After installing required tools:" -ForegroundColor Green
Write-Host "git clone <your-repo>" -ForegroundColor Gray
Write-Host "cd dogeTech" -ForegroundColor Gray
Write-Host "npm run secrets:setup  # Setup GitHub tokens" -ForegroundColor Gray
Write-Host "npm run docker:dev     # Start development environment" -ForegroundColor Gray
Write-Host ""
Write-Host "# Alternative without npm:" -ForegroundColor Green
Write-Host "docker-compose up app-dev" -ForegroundColor Gray

# Exit with appropriate code
if ($MissingRequired.Count -gt 0) {
    exit 1
} else {
    exit 0
}