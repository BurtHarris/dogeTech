# Docker Secrets Setup Script for Windows
# Run this in PowerShell to set up GitHub secrets

Write-Host "🔐 Setting up Docker Secrets for GitHub Integration" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

# Create secrets directory if it doesn't exist
if (!(Test-Path "secrets")) {
    New-Item -ItemType Directory -Path "secrets" | Out-Null
    Write-Host "📁 Created secrets directory" -ForegroundColor Green
}

# Function to create secret file
function Create-Secret {
    param($SecretName)
    
    $secretFile = "secrets\$SecretName.txt"
    $exampleFile = "secrets\$SecretName.txt.example"
    
    if (Test-Path $secretFile) {
        Write-Host "⚠️  $secretFile already exists" -ForegroundColor Yellow
        $replace = Read-Host "Do you want to replace it? (y/N)"
        if ($replace -ne "y" -and $replace -ne "Y") {
            return
        }
    }
    
    Write-Host "Please enter your ${SecretName}:" -ForegroundColor Yellow
    $token = Read-Host -AsSecureString
    $plainToken = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($token))
    
    $plainToken | Out-File -FilePath $secretFile -NoNewline -Encoding utf8
    Write-Host "✅ $secretFile created" -ForegroundColor Green
}

Write-Host ""
Write-Host "📝 You'll need to create GitHub tokens at:" -ForegroundColor Yellow
Write-Host "   https://github.com/settings/tokens" -ForegroundColor White
Write-Host ""
Write-Host "Required scopes for the token:" -ForegroundColor Yellow
Write-Host "   - repo (for repository access)" -ForegroundColor White
Write-Host "   - read:user (for user information)" -ForegroundColor White
Write-Host "   - copilot (for GitHub Copilot access)" -ForegroundColor White
Write-Host ""

# Create GitHub token
Create-Secret "github_token"

Write-Host ""
$sameToken = Read-Host "Use the same token for GitHub CLI? (Y/n)"
if ($sameToken -eq "n" -or $sameToken -eq "N") {
    Create-Secret "gh_token"
} else {
    if (Test-Path "secrets\github_token.txt") {
        Copy-Item "secrets\github_token.txt" "secrets\gh_token.txt"
        Write-Host "✅ GitHub CLI token set to same value" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "🎉 Docker secrets setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "💡 Next steps:" -ForegroundColor Cyan
Write-Host "   1. Start your container: npm run docker:dev" -ForegroundColor White
Write-Host "   2. Setup GitHub tools: npm run github:setup" -ForegroundColor White
Write-Host "   3. The secrets will be available at /run/secrets/ in the container" -ForegroundColor White