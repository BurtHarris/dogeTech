# 🐕 DogeTech Development Environment

A Docker-based development environment for Node.js/TypeScript projects.

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

### Useful Commands

```bash
# Install dependencies
npm install

# Build the project
npm run build

# Get a shell inside the running container
npm run docker:shell

# Rebuild containers
npm run docker:build
```

## Features

- 🔄 **Hot Reload**: Automatic restart on file changes
- 🐛 **Debugging**: Debug port exposed on `9229`
- 📦 **Multi-stage Build**: Optimized production builds
- 🛠️ **Development Tools**: Git, vim, nano, htop included
- 🔍 **Type Safety**: Full TypeScript support

## Development

The development container includes:
- Node.js 20 LTS
- TypeScript with hot reload
- Debug port (9229) for VS Code debugging
- Volume mounting for live code changes
- Development tools and utilities

## Debugging

To debug with VS Code:
1. Start the development container: `npm run docker:dev`
2. Attach VS Code debugger to `localhost:9229`
3. Set breakpoints and debug!

## Environment Variables

- `NODE_ENV`: Set to `development` or `production`
- `PORT`: Application port (default: 3000)
- `DEBUG`: Debug namespaces

## Project Structure

```
.
├── src/              # Source code
├── dist/             # Compiled output
├── docker-compose.yml
├── Dockerfile
└── package.json
```