# 🐕 DogeTech Development Environment

**A complete Docker-based development environment setup for Node.js/TypeScript projects.**

> 🎯 **Purpose**: This package provides a ready-to-use dockerized development environment with hot reload, debugging support, and production builds. Perfect for consistent development across different machines and teams.

## Quick Start

### Development Mode
```bash
# Build and start development container
npm run docker:dev

# Or manually with docker-compose
docker-compose up app-dev
```

### Production Mode
```bash
# Build and start production container
npm run docker:prod
```

### Essential Commands

```bash
# Install dependencies (run once)
npm install

# Start development environment with hot reload
npm run docker:dev

# Start production environment
npm run docker:prod

# Get interactive shell access to running container
npm run docker:shell

# Rebuild Docker containers (after Dockerfile changes)
npm run docker:build

# Build TypeScript locally
npm run build

# Stop all containers
docker-compose down
```

## What's Included

This dockerized development environment provides:

- 🔄 **Hot Reload**: Automatic restart on file changes with `ts-node-dev`
- 🐛 **Remote Debugging**: Debug port exposed on `9229` for VS Code
- 📦 **Multi-stage Builds**: Separate optimized development and production containers
- 🛠️ **Development Tools**: Git, vim, nano, htop, curl pre-installed
- 🔍 **Full TypeScript Support**: Configured with proper types and compilation
- 🐳 **Docker Compose**: Easy container orchestration for dev/prod environments
- 📁 **Volume Mounting**: Live code editing without container rebuilds
- 🌐 **API Ready**: Sample HTTP server listening on port 3000

## Container Specifications

### Development Container (`app-dev`)
- **Base**: Node.js 20 LTS (slim)
- **Tools**: Git, vim, nano, htop, curl, procps
- **TypeScript**: Hot reload with `ts-node-dev`
- **Debugging**: Port 9229 exposed for remote debugging
- **Volumes**: Live code mounting with `node_modules` isolation
- **Environment**: `NODE_ENV=development`

### Production Container (`app-prod`)
- **Base**: Node.js 20 LTS (slim) 
- **Optimized**: Multi-stage build with only production dependencies
- **Compiled**: Pre-built TypeScript to JavaScript
- **Environment**: `NODE_ENV=production`

## Debugging with VS Code

1. Start development container: `npm run docker:dev`
2. In VS Code, go to Run & Debug (Ctrl+Shift+D)
3. Create launch configuration:
   ```json
   {
     "type": "node",
     "request": "attach",
     "name": "Docker Debug",
     "port": 9229,
     "restart": true,
     "remoteRoot": "/usr/src/app"
   }
   ```
4. Set breakpoints and start debugging!

## Configuration

### Environment Variables
- `NODE_ENV`: `development` or `production`
- `PORT`: Application port (default: 3000)
- `DEBUG`: Debug namespaces for enhanced logging

### Ports
- **3000**: Application HTTP server
- **9229**: Node.js debug/inspector port

## Project Structure

```
dogetech-dev-env/
├── src/
│   └── index.ts                    # Sample TypeScript application
├── dist/                           # Compiled JavaScript output
├── node_modules/                   # Dependencies (gitignored)
├── .gitignore                      # Comprehensive ignore rules
├── docker-compose.yml              # Container orchestration
├── dockerfile                      # Multi-stage container definition  
├── package.json                    # Dependencies and scripts
├── tsconfig.json                   # TypeScript configuration
├── docker-compose.override.example.yml  # Local development overrides
└── README.md                       # This file
```

## Getting Started

1. **Clone or download this repository**
2. **Install dependencies**: `npm install`
3. **Start development**: `npm run docker:dev`
4. **Access your app**: Visit `http://localhost:3000`
5. **Start coding**: Edit files in `src/` and watch them reload automatically!

## Use Cases

Perfect for:
- ✅ **Team Development**: Consistent environment across all developers
- ✅ **CI/CD Pipelines**: Reproducible builds and deployments  
- ✅ **Learning Docker**: Complete example with best practices
- ✅ **Microservices**: Template for containerized Node.js services
- ✅ **Remote Development**: Works great with VS Code Remote-Containers

---

**Built with ❤️ for developers who want a hassle-free Docker development experience.**