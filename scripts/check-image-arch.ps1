#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Check the architecture of DogeTech Docker images
.DESCRIPTION
    This script inspects Docker images and displays their architecture information,
    including which PowerShell binary was installed.
.PARAMETER ImageName
    The Docker image name to inspect (defaults to dogetech-app-dev:latest)
#>

param(
    [string]$ImageName = "dogetech-app-dev:latest"
)

Write-Host "🔍 DogeTech Image Architecture Inspector" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""

try {
    # Get image labels
    $labels = docker inspect $ImageName --format='{{json .Config.Labels}}' | ConvertFrom-Json
    
    if ($labels) {
        Write-Host "📊 Image: $ImageName" -ForegroundColor Yellow
        Write-Host ""
        
        # Architecture information
        Write-Host "🏗️  Architecture Details:" -ForegroundColor Green
        Write-Host "   Target Architecture: $($labels.'org.opencontainers.image.architecture')" -ForegroundColor White
        Write-Host "   Platform: $($labels.'org.opencontainers.image.platform')" -ForegroundColor White
        Write-Host ""
        
        # Version information
        Write-Host "📦 Software Versions:" -ForegroundColor Green
        Write-Host "   DogeTech Version: $($labels.'org.opencontainers.image.version')" -ForegroundColor White
        Write-Host "   PowerShell Version: $($labels.'dogetech.powershell.version')" -ForegroundColor White
        Write-Host "   Node.js Version: $($labels.'dogetech.nodejs.version')" -ForegroundColor White
        Write-Host ""
        
        # PowerShell binary info
        $arch = $labels.'org.opencontainers.image.architecture'
        $psArch = if ($arch -eq "amd64") { "x64" } else { $arch }
        Write-Host "💻 PowerShell Binary:" -ForegroundColor Green
        Write-Host "   Expected Binary: powershell-7.4.6-linux-$psArch.tar.gz" -ForegroundColor White
        Write-Host ""
        
        # Image metadata
        Write-Host "📋 Image Metadata:" -ForegroundColor Green
        Write-Host "   Title: $($labels.'org.opencontainers.image.title')" -ForegroundColor White
        Write-Host "   Description: $($labels.'org.opencontainers.image.description')" -ForegroundColor White
        
    } else {
        Write-Host "❌ No labels found for image: $ImageName" -ForegroundColor Red
    }
    
} catch {
    Write-Host "❌ Error inspecting image '$ImageName': $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "💡 Make sure the image exists. Run 'docker images' to list available images." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "✅ Architecture inspection complete!" -ForegroundColor Green