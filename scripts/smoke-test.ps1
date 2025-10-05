# Comprehensive Smoke Test for DogeTech Development Environment
# Tests container functionality, API endpoints, secrets, and tools

param(
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"

Write-Host "🧪 DogeTech Development Environment - Smoke Test" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan

# Test configuration
$TEST_GITHUB_TOKEN = "test_token_12345"
$TEST_GH_TOKEN = "test_gh_token_67890"
$API_PORT = "3000"
$CONTAINER_NAME = "dogetech-app-dev-1"

# Test counters
$TESTS_PASSED = 0
$TESTS_FAILED = 0

# Helper functions
function Pass-Test {
    param($Message)
    Write-Host "✅ PASS: $Message" -ForegroundColor Green
    $script:TESTS_PASSED++
}

function Fail-Test {
    param($Message)
    Write-Host "❌ FAIL: $Message" -ForegroundColor Red
    $script:TESTS_FAILED++
}

function Warn-Test {
    param($Message)
    Write-Host "⚠️  WARN: $Message" -ForegroundColor Yellow
}

# Cleanup function
function Cleanup {
    Write-Host ""
    Write-Host "🧹 Cleaning up test environment..." -ForegroundColor Yellow
    try {
        docker-compose down -v 2>$null
        Remove-Item -Path "secrets\github_token.txt", "secrets\gh_token.txt" -ErrorAction SilentlyContinue
        Write-Host "✅ Cleanup complete" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  Cleanup had some issues, but continuing..." -ForegroundColor Yellow
    }
}

# Register cleanup for script exit
Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action { Cleanup }

try {
    Write-Host ""
    Write-Host "📝 Test Plan:" -ForegroundColor Yellow
    Write-Host "  1. Setup test secrets"
    Write-Host "  2. Build container"
    Write-Host "  3. Start development environment"
    Write-Host "  4. Test API endpoints"
    Write-Host "  5. Test container tools"
    Write-Host "  6. Test secrets accessibility"
    Write-Host "  7. Test PowerShell availability"
    Write-Host "  8. Test GitHub tools installation"
    Write-Host ""

    # Test 1: Setup test secrets
    Write-Host "🔐 Test 1: Setting up test secrets..." -ForegroundColor Cyan
    if (!(Test-Path "secrets")) {
        New-Item -ItemType Directory -Path "secrets" | Out-Null
    }
    
    $TEST_GITHUB_TOKEN | Out-File -FilePath "secrets\github_token.txt" -NoNewline -Encoding utf8
    $TEST_GH_TOKEN | Out-File -FilePath "secrets\gh_token.txt" -NoNewline -Encoding utf8

    if ((Test-Path "secrets\github_token.txt") -and (Test-Path "secrets\gh_token.txt")) {
        Pass-Test "Test secrets created successfully"
    } else {
        Fail-Test "Failed to create test secrets"
        exit 1
    }

    # Test 2: Build container
    Write-Host ""
    Write-Host "🏗️  Test 2: Building container..." -ForegroundColor Cyan
    $buildResult = docker-compose build app-dev --quiet 2>&1
    if ($LASTEXITCODE -eq 0) {
        Pass-Test "Container built successfully"
    } else {
        Fail-Test "Container build failed: $buildResult"
        exit 1
    }

    # Test 3: Start development environment
    Write-Host ""
    Write-Host "🚀 Test 3: Starting development environment..." -ForegroundColor Cyan
    $startResult = docker-compose up app-dev -d 2>&1
    if ($LASTEXITCODE -eq 0) {
        Pass-Test "Development environment started"
    } else {
        Fail-Test "Failed to start development environment: $startResult"
        exit 1
    }

    # Wait for container to be ready
    Write-Host "⏳ Waiting for container to be ready..."
    Start-Sleep -Seconds 8

    # Test 4: Test API endpoints
    Write-Host ""
    Write-Host "🌐 Test 4: Testing API endpoints..." -ForegroundColor Cyan

    # Check if container is running
    $containerStatus = docker-compose ps app-dev
    if ($containerStatus -match "Up") {
        Pass-Test "Container is running"
    } else {
        Fail-Test "Container is not running"
    }

    # Test API endpoint
    try {
        $apiResponse = Invoke-RestMethod -Uri "http://localhost:$API_PORT" -TimeoutSec 10
        if ($apiResponse.message -match "DogeTech API is running") {
            Pass-Test "API endpoint responding correctly"
        } else {
            Fail-Test "API endpoint response incorrect"
        }
    } catch {
        Fail-Test "API endpoint not accessible: $($_.Exception.Message)"
    }

    # Test 5: Test container tools
    Write-Host ""
    Write-Host "🛠️  Test 5: Testing container tools..." -ForegroundColor Cyan

    $tools = @("git", "curl", "vim", "nano", "node", "npm")
    foreach ($tool in $tools) {
        docker-compose exec -T app-dev which $tool 2>$null | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Pass-Test "Tool '$tool' is available"
        } else {
            Fail-Test "Tool '$tool' is not available"
        }
    }
    
    # Test TypeScript compiler (installed locally)
    docker-compose exec -T app-dev npx tsc --version 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Pass-Test "TypeScript compiler (tsc) is available via npx"
    } else {
        Fail-Test "TypeScript compiler (tsc) is not available"
    }

    # Test Node.js version
    $nodeVersion = docker-compose exec -T app-dev node --version 2>$null
    if ($nodeVersion -match "v20\.") {
        Pass-Test "Node.js version $($nodeVersion.Trim()) is correct"
    } else {
        Fail-Test "Node.js version incorrect or not found: $nodeVersion"
    }

    # Test 6: Test secrets accessibility
    Write-Host ""
    Write-Host "🔒 Test 6: Testing secrets accessibility..." -ForegroundColor Cyan

    # Check if secrets directory exists
    $secretsDirCheck = docker-compose exec -T app-dev test -d /run/secrets 2>$null
    if ($LASTEXITCODE -eq 0) {
        Pass-Test "Secrets directory exists in container"
    } else {
        Fail-Test "Secrets directory not found in container"
    }

    # Check if secrets are accessible
    $githubSecret = docker-compose exec -T app-dev cat /run/secrets/github_token 2>$null
    $ghSecret = docker-compose exec -T app-dev cat /run/secrets/gh_token 2>$null

    if ($githubSecret.Trim() -eq $TEST_GITHUB_TOKEN) {
        Pass-Test "GitHub token secret accessible and correct"
    } else {
        Fail-Test "GitHub token secret not accessible or incorrect"
    }

    if ($ghSecret.Trim() -eq $TEST_GH_TOKEN) {
        Pass-Test "GitHub CLI token secret accessible and correct"
    } else {
        Fail-Test "GitHub CLI token secret not accessible or incorrect"
    }

    # Test 7: Test PowerShell availability (optional)
    Write-Host ""
    Write-Host "💻 Test 7: Testing PowerShell availability (optional)..." -ForegroundColor Cyan

    $psTest = docker-compose exec -T app-dev pwsh -Command "Write-Host 'PowerShell works'" 2>$null
    if ($psTest -match "PowerShell works") {
        Pass-Test "PowerShell is available and working"
        
        # Test PowerShell version
        $psVersion = docker-compose exec -T app-dev pwsh -Command '$PSVersionTable.PSVersion.ToString()' 2>$null
        if ($psVersion -match "7\.") {
            Pass-Test "PowerShell version $($psVersion.Trim()) is correct"
        } else {
            Warn-Test "PowerShell version unexpected: $psVersion"
        }
    } else {
        Warn-Test "PowerShell is not available (this is optional - can be installed later)"
    }

    # Test 8: Test GitHub tools installation capability
    Write-Host ""
    Write-Host "🤖 Test 8: Testing GitHub tools installation..." -ForegroundColor Cyan

    $scriptCheck = docker-compose exec -T app-dev test -f /usr/src/app/scripts/github-setup.sh 2>$null
    if ($LASTEXITCODE -eq 0) {
        Pass-Test "GitHub setup script is present"
    } else {
        Fail-Test "GitHub setup script is missing"
    }

    # Test TypeScript compilation
    Write-Host ""
    Write-Host "📦 Test 9: Testing TypeScript compilation..." -ForegroundColor Cyan
    $buildTest = docker-compose exec -T app-dev npm run build 2>$null
    if ($LASTEXITCODE -eq 0) {
        Pass-Test "TypeScript compilation successful"
    } else {
        Fail-Test "TypeScript compilation failed"
    }

    # Test that compiled files exist
    $jsFileCheck = docker-compose exec -T app-dev test -f /usr/src/app/dist/index.js 2>$null
    if ($LASTEXITCODE -eq 0) {
        Pass-Test "Compiled JavaScript files exist"
    } else {
        Fail-Test "Compiled JavaScript files not found"
    }

    # Final results
    Write-Host ""
    Write-Host "📊 Test Results Summary" -ForegroundColor Cyan
    Write-Host "======================" -ForegroundColor Cyan
    Write-Host "Tests Passed: " -NoNewline
    Write-Host $TESTS_PASSED -ForegroundColor Green
    Write-Host "Tests Failed: " -NoNewline  
    Write-Host $TESTS_FAILED -ForegroundColor Red
    Write-Host "Total Tests:  $($TESTS_PASSED + $TESTS_FAILED)"

    if ($TESTS_FAILED -eq 0) {
        Write-Host ""
        Write-Host "🎉 All tests passed! DogeTech development environment is working correctly." -ForegroundColor Green
        exit 0
    } else {
        Write-Host ""
        Write-Host "❌ Some tests failed. Please check the output above for details." -ForegroundColor Red
        exit 1
    }

} finally {
    Cleanup
}