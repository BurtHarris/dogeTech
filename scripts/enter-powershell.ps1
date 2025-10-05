#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Enter PowerShell session in the DogeTech development container
.DESCRIPTION
    This script provides an easy way to start a PowerShell session in the running
    DogeTech development container with Windows-friendly commands and shortcuts.
.EXAMPLE
    .\scripts\enter-powershell.ps1
    Starts PowerShell in the running app-dev container
.EXAMPLE
    .\scripts\enter-powershell.ps1 -Container app-prod
    Starts PowerShell in the app-prod container
#>

param(
    [string]$Container = "app-dev",
    [switch]$Help
)

if ($Help) {
    Get-Help $MyInvocation.MyCommand.Path -Full
    exit 0
}

Write-Host "🐕 Entering PowerShell in DogeTech container..." -ForegroundColor Green

# Check if Docker is running
try {
    docker info | Out-Null
} catch {
    Write-Error "❌ Docker is not running. Please start Docker Desktop first."
    exit 1
}

# Check if container is running
$containerStatus = docker ps --filter "name=$Container" --format "{{.Status}}" 2>$null
if (-not $containerStatus) {
    Write-Warning "⚠️  Container '$Container' is not running."
    Write-Host "Starting container..." -ForegroundColor Yellow
    
    try {
        docker-compose up -d $Container
        Start-Sleep 3
    } catch {
        Write-Error "❌ Failed to start container '$Container'"
        exit 1
    }
}

Write-Host "🚀 Connecting to PowerShell in container '$Container'..." -ForegroundColor Cyan
Write-Host "💡 Tip: You'll have familiar Windows commands like dir, cls, type, etc." -ForegroundColor Yellow
Write-Host "🔧 Quick dev commands: build, dev, test, start" -ForegroundColor Magenta
Write-Host ""

# Enter PowerShell in the container
docker exec -it $Container pwsh