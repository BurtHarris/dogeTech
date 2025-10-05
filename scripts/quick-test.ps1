# Quick Test - Basic functionality without secrets
# Tests core container functionality

Write-Host "🔬 DogeTech - Quick Test (No Secrets Required)" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

$TESTS_PASSED = 0
$TESTS_FAILED = 0

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

try {
    # Test 1: Build container
    Write-Host ""
    Write-Host "🏗️  Building container..." -ForegroundColor Yellow
    docker-compose build app-dev --quiet
    if ($LASTEXITCODE -eq 0) {
        Pass-Test "Container built successfully"
    } else {
        Fail-Test "Container build failed"
        exit 1
    }

    # Test 2: Start container (without secrets)
    Write-Host ""
    Write-Host "🚀 Starting container..." -ForegroundColor Yellow
    
    # Create temporary docker-compose for testing without secrets
    $originalCompose = Get-Content "docker-compose.yml" -Raw
    $testCompose = $originalCompose -replace 'secrets:\s*\n\s*- github_token\s*\n\s*- gh_token', ''
    $testCompose | Out-File -FilePath "docker-compose.test.yml" -Encoding utf8
    
    docker-compose -f docker-compose.test.yml up app-dev -d
    if ($LASTEXITCODE -eq 0) {
        Pass-Test "Container started successfully"
    } else {
        Fail-Test "Container failed to start"
        exit 1
    }

    Start-Sleep -Seconds 5

    # Test 3: API endpoint
    Write-Host ""
    Write-Host "🌐 Testing API..." -ForegroundColor Yellow
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:3000" -TimeoutSec 10
        if ($response.message -match "DogeTech API is running") {
            Pass-Test "API responding correctly"
        } else {
            Fail-Test "API response incorrect"
        }
    } catch {
        Fail-Test "API not accessible: $($_.Exception.Message)"
    }

    # Test 4: Basic shell functionality
    Write-Host ""
    Write-Host "� Testing shell functionality..." -ForegroundColor Yellow
    $shellTest = docker-compose -f docker-compose.test.yml exec -T app-dev echo "SHELL-OK" 2>$null
    if ($shellTest -match "SHELL-OK") {
        Pass-Test "Shell functionality working"
    } else {
        Fail-Test "Shell functionality not working"
    }

    # Test 5: TypeScript compilation
    Write-Host ""
    Write-Host "📦 Testing TypeScript compilation..." -ForegroundColor Yellow
    docker-compose -f docker-compose.test.yml exec -T app-dev npm run build 2>$null
    if ($LASTEXITCODE -eq 0) {
        Pass-Test "TypeScript compilation successful"
    } else {
        Fail-Test "TypeScript compilation failed"
    }

} finally {
    # Cleanup
    Write-Host ""
    Write-Host "🧹 Cleaning up..." -ForegroundColor Yellow
    docker-compose -f docker-compose.test.yml down -v 2>$null
    Remove-Item -Path "docker-compose.test.yml" -ErrorAction SilentlyContinue
}

# Results
Write-Host ""
Write-Host "📊 Quick Test Results" -ForegroundColor Cyan
Write-Host "===================" -ForegroundColor Cyan
Write-Host "Passed: $TESTS_PASSED" -ForegroundColor Green
Write-Host "Failed: $TESTS_FAILED" -ForegroundColor Red

if ($TESTS_FAILED -eq 0) {
    Write-Host ""
    Write-Host "🎉 Quick test passed! Core functionality working." -ForegroundColor Green
    exit 0
} else {
    Write-Host ""
    Write-Host "❌ Quick test failed. Check output above." -ForegroundColor Red
    exit 1
}