# Multi-stage Dockerfile for Node.js/TypeScript development
# Learn more: https://docs.docker.com/build/building/multi-stage/

# Use an official Node.js LTS image as base
FROM node:20-slim AS base

# Install essential development tools and PowerShell
# Package info: https://docs.microsoft.com/en-us/powershell/scripting/install/install-debian
RUN apt-get update && apt-get install -y \
    git \
    curl \
    vim \
    nano \
    procps \
    htop \
    sudo \
    wget \
    ca-certificates \
    gnupg \
    # Always install AMD64 PowerShell - Docker handles emulation on ARM64
    && PWSH_VERSION="7.4.6" \
    && PWSH_URL="https://github.com/PowerShell/PowerShell/releases/download/v${PWSH_VERSION}/powershell_${PWSH_VERSION}-1.deb_amd64.deb" \
    && echo "Installing PowerShell ${PWSH_VERSION} for AMD64..." \
    && wget -O /tmp/powershell.deb "$PWSH_URL" \
    && dpkg -i /tmp/powershell.deb || true \
    && apt-get install -f -y \
    && rm -f /tmp/powershell.deb \
    && rm -rf /var/lib/apt/lists/*

# Verify PowerShell installation
RUN pwsh --version || echo "PowerShell installation verification failed"

# Set working directory inside container
WORKDIR /usr/src/app

# Copy package files first for better Docker layer caching
# Learn more: https://docs.docker.com/build/cache/
COPY package*.json tsconfig.json ./

# Install Node.js dependencies
RUN npm ci

# Copy source code (after dependencies for better caching)
COPY . .

# Development stage - includes dev tools and doesn't build
FROM base AS development

# Expose development ports (app + debugger)
EXPOSE 3000 9229

# Use nodemon for hot reload in development
CMD ["npm", "run", "dev"]

# --- Build stage for production ---
FROM base AS builder

# Compile TypeScript to JavaScript
RUN npm run build

# --- Production stage ---
# Multi-stage build: smaller production image without dev dependencies
FROM node:20-slim AS production

WORKDIR /usr/src/app

# Copy only compiled code and package files from builder stage
COPY --from=builder /usr/src/app/dist ./dist
COPY package*.json ./

# Install only production dependencies (smaller image)
RUN npm ci --only=production

# Expose port for the application
EXPOSE 3000

# Start the application
CMD ["node", "dist/index.js"]
