#!/bin/bash

# Enter PowerShell session in the DogeTech development container
# Usage: ./scripts/enter-powershell.sh [container-name]

CONTAINER=${1:-"app-dev"}

echo "🐕 Entering PowerShell in DogeTech container..."

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo "❌ Docker is not running. Please start Docker Desktop first."
    exit 1
fi

# Check if container is running
if ! docker ps --filter "name=$CONTAINER" --format "{{.Status}}" &> /dev/null; then
    echo "⚠️  Container '$CONTAINER' is not running."
    echo "Starting container..."
    
    if ! docker-compose up -d $CONTAINER; then
        echo "❌ Failed to start container '$CONTAINER'"
        exit 1
    fi
    
    sleep 3
fi

echo "🚀 Connecting to PowerShell in container '$CONTAINER'..."
echo "💡 Tip: You'll have familiar Windows commands like dir, cls, type, etc."
echo "🔧 Quick dev commands: build, dev, test, start"
echo ""

# Enter PowerShell in the container
docker exec -it $CONTAINER pwsh