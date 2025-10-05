#!/bin/bash

# Comprehensive Smoke Test for DogeTech Development Environment
# Tests container functionality, API endpoints, secrets, and tools

set -e  # Exit on any error

echo "# Test 7: Test PowerShell availability (required)
echo ""
echo "💻 Test 7: Testing PowerShell availability..." 

if docker-compose exec -T app-dev pwsh -Command "Write-Host 'PowerShell works'" 2>/dev/null | grep -q "PowerShell works"; then
    pass_test "PowerShell is available and working"
    
    # Test PowerShell version
    PS_VERSION=$(docker-compose exec -T app-dev pwsh -Command '$PSVersionTable.PSVersion.ToString()' 2>/dev/null || echo "")
    if [[ "$PS_VERSION" == "7."* ]]; then
        pass_test "PowerShell version $PS_VERSION is correct"
    else
        fail_test "PowerShell version unexpected: $PS_VERSION"
    fi
    
    # Test PowerShell basic commands
    if docker-compose exec -T app-dev pwsh -Command "Get-Location" 2>/dev/null | grep -q "/usr/src/app"; then
        pass_test "PowerShell Get-Location command works"
    else
        fail_test "PowerShell Get-Location command failed"
    fi
    
    # Test PowerShell file operations
    if docker-compose exec -T app-dev pwsh -Command "Get-ChildItem" 2>/dev/null | grep -q "package.json"; then
        pass_test "PowerShell Get-ChildItem command works"
    else
        fail_test "PowerShell Get-ChildItem command failed"
    fi
else
    fail_test "PowerShell is not available - required for Windows developers"
fiopment Environment - Smoke Test"
echo "==============================================="

# Test configuration
TEST_GITHUB_TOKEN="test_token_12345"
TEST_GH_TOKEN="test_gh_token_67890"
API_PORT="3000"
CONTAINER_NAME="dogetech-app-dev-1"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Helper functions
pass_test() {
    echo -e "${GREEN}✅ PASS${NC}: $1"
    ((TESTS_PASSED++))
}

fail_test() {
    echo -e "${RED}❌ FAIL${NC}: $1"
    ((TESTS_FAILED++))
}

warn_test() {
    echo -e "${YELLOW}⚠️  WARN${NC}: $1"
}

# Cleanup function
cleanup() {
    echo ""
    echo "🧹 Cleaning up test environment..."
    docker-compose down -v 2>/dev/null || true
    rm -f secrets/github_token.txt secrets/gh_token.txt 2>/dev/null || true
    echo "✅ Cleanup complete"
}

# Setup trap for cleanup
trap cleanup EXIT

echo ""
echo "📝 Test Plan:"
echo "  1. Setup test secrets"
echo "  2. Build container"
echo "  3. Start development environment"
echo "  4. Test API endpoints"
echo "  5. Test container tools"
echo "  6. Test secrets accessibility"
echo "  7. Test PowerShell availability (required)"
echo "  8. Test GitHub tools installation"
echo ""

# Test 1: Setup test secrets
echo "🔐 Test 1: Setting up test secrets..."
mkdir -p secrets
echo -n "$TEST_GITHUB_TOKEN" > secrets/github_token.txt
echo -n "$TEST_GH_TOKEN" > secrets/gh_token.txt
chmod 600 secrets/*.txt

if [ -f "secrets/github_token.txt" ] && [ -f "secrets/gh_token.txt" ]; then
    pass_test "Test secrets created successfully"
else
    fail_test "Failed to create test secrets"
    exit 1
fi

# Test 2: Build container
echo ""
echo "🏗️  Test 2: Building container..."
if docker-compose build app-dev --quiet; then
    pass_test "Container built successfully"
else
    fail_test "Container build failed"
    exit 1
fi

# Test 3: Start development environment
echo ""
echo "🚀 Test 3: Starting development environment..."
if docker-compose up app-dev -d; then
    pass_test "Development environment started"
else
    fail_test "Failed to start development environment"
    exit 1
fi

# Wait for container to be ready
echo "⏳ Waiting for container to be ready..."
sleep 5

# Test 4: Test API endpoints
echo ""
echo "🌐 Test 4: Testing API endpoints..."

# Check if container is running
if docker-compose ps app-dev | grep -q "Up"; then
    pass_test "Container is running"
else
    fail_test "Container is not running"
fi

# Test API endpoint
if curl -f -s http://localhost:$API_PORT > /dev/null; then
    API_RESPONSE=$(curl -s http://localhost:$API_PORT)
    if echo "$API_RESPONSE" | grep -q "DogeTech API is running"; then
        pass_test "API endpoint responding correctly"
    else
        fail_test "API endpoint response incorrect"
    fi
else
    fail_test "API endpoint not accessible"
fi

# Test 5: Test container tools
echo ""
echo "🛠️  Test 5: Testing container tools..."

    # Test basic tools
    TOOLS=("git" "curl" "vim" "nano" "node" "npm")
    for tool in "${TOOLS[@]}"; do
        if docker-compose exec -T app-dev which "$tool" > /dev/null 2>&1; then
            pass_test "Tool '$tool' is available"
        else
            fail_test "Tool '$tool' is not available"
        fi
    done
    
    # Test TypeScript compiler (installed locally)
    if docker-compose exec -T app-dev npx tsc --version > /dev/null 2>&1; then
        pass_test "TypeScript compiler (tsc) is available via npx"
    else
        fail_test "TypeScript compiler (tsc) is not available"
    fi# Test Node.js version
NODE_VERSION=$(docker-compose exec -T app-dev node --version 2>/dev/null || echo "")
if [[ "$NODE_VERSION" =~ v20\. ]]; then
    pass_test "Node.js version $NODE_VERSION is correct"
else
    fail_test "Node.js version incorrect or not found: $NODE_VERSION"
fi

# Test 6: Test secrets accessibility
echo ""
echo "🔒 Test 6: Testing secrets accessibility..."

# Check if secrets directory exists
if docker-compose exec -T app-dev test -d /run/secrets; then
    pass_test "Secrets directory exists in container"
else
    fail_test "Secrets directory not found in container"
fi

# Check if secrets are accessible
GITHUB_SECRET=$(docker-compose exec -T app-dev cat /run/secrets/github_token 2>/dev/null || echo "")
GH_SECRET=$(docker-compose exec -T app-dev cat /run/secrets/gh_token 2>/dev/null || echo "")

if [ "$GITHUB_SECRET" = "$TEST_GITHUB_TOKEN" ]; then
    pass_test "GitHub token secret accessible and correct"
else
    fail_test "GitHub token secret not accessible or incorrect"
fi

if [ "$GH_SECRET" = "$TEST_GH_TOKEN" ]; then
    pass_test "GitHub CLI token secret accessible and correct"
else
    fail_test "GitHub CLI token secret not accessible or incorrect"
fi

# Test 7: Test PowerShell availability (optional)
echo ""
echo "💻 Test 7: Testing PowerShell availability (optional)..."

if docker-compose exec -T app-dev pwsh -Command "Write-Host 'PowerShell works'" 2>/dev/null | grep -q "PowerShell works"; then
    pass_test "PowerShell is available and working"
    
    # Test PowerShell version
    PS_VERSION=$(docker-compose exec -T app-dev pwsh -Command '$PSVersionTable.PSVersion.ToString()' 2>/dev/null || echo "")
    if [[ "$PS_VERSION" =~ 7\. ]]; then
        pass_test "PowerShell version $PS_VERSION is correct"
    else
        warn_test "PowerShell version unexpected: $PS_VERSION"
    fi
else
    warn_test "PowerShell is not available (this is optional - can be installed later)"
fi

# Test 8: Test GitHub tools installation capability
echo ""
echo "🤖 Test 8: Testing GitHub tools installation..."

# Test that the GitHub setup script exists and is executable
if docker-compose exec -T app-dev test -f /usr/src/app/scripts/github-setup.sh; then
    pass_test "GitHub setup script is present"
else
    fail_test "GitHub setup script is missing"
fi

# Test TypeScript compilation
echo ""
echo "📦 Test 9: Testing TypeScript compilation..."
if docker-compose exec -T app-dev npm run build > /dev/null 2>&1; then
    pass_test "TypeScript compilation successful"
else
    fail_test "TypeScript compilation failed"
fi

# Test that compiled files exist
if docker-compose exec -T app-dev test -f /usr/src/app/dist/index.js; then
    pass_test "Compiled JavaScript files exist"
else
    fail_test "Compiled JavaScript files not found"
fi

# Final results
echo ""
echo "📊 Test Results Summary"
echo "======================"
echo -e "Tests Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests Failed: ${RED}$TESTS_FAILED${NC}"
echo -e "Total Tests:  $((TESTS_PASSED + TESTS_FAILED))"

if [ $TESTS_FAILED -eq 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 All tests passed! DogeTech development environment is working correctly.${NC}"
    exit 0
else
    echo ""
    echo -e "${RED}❌ Some tests failed. Please check the output above for details.${NC}"
    exit 1
fi