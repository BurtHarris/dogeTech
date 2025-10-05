# Multi-stage Dockerfile for Node.js/TypeScript development
# Learn more: https://docs.docker.com/build/building/multi-stage/

# Use Ubuntu 22.04 as base for native PowerShell support
FROM ubuntu:22.04 AS base

# Docker build arguments for architecture detection
ARG TARGETARCH
ARG BUILDPLATFORM
ARG TARGETPLATFORM

# Add labels for better image identification and management
LABEL org.opencontainers.image.title="DogeTech Development Environment"
LABEL org.opencontainers.image.description="Node.js/TypeScript development with cross-platform PowerShell support"
LABEL org.opencontainers.image.version="0.1.1"
LABEL org.opencontainers.image.architecture="${TARGETARCH}"
LABEL org.opencontainers.image.platform="${TARGETPLATFORM}"
LABEL dogetech.powershell.version="7.4.6"
LABEL dogetech.nodejs.version="20.19.5"

# Prevent interactive prompts during package installations
ENV DEBIAN_FRONTEND=noninteractive

# Install Node.js 20 LTS and essential development tools
RUN apt-get update && apt-get install -y \
    # Node.js installation dependencies
    ca-certificates \
    curl \
    gnupg \
    # Essential development tools
    git \
    vim \
    nano \
    procps \
    htop \
    sudo \
    wget \
    # PowerShell dependencies
    libicu70 \
    # Add NodeSource repository for Node.js 20 LTS
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -y nodejs \
    # Install PowerShell based on target architecture
    && if [ "$TARGETARCH" = "amd64" ]; then \
        echo "Installing PowerShell for AMD64..." && \
        wget -q https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/powershell-7.4.6-linux-x64.tar.gz -O powershell.tar.gz; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        echo "Installing PowerShell for ARM64..." && \
        wget -q https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/powershell-7.4.6-linux-arm64.tar.gz -O powershell.tar.gz; \
    else \
        echo "Unsupported architecture: $TARGETARCH" && exit 1; \
    fi \
    && mkdir -p /opt/microsoft/powershell/7 \
    && tar zxf powershell.tar.gz -C /opt/microsoft/powershell/7 \
    && chmod +x /opt/microsoft/powershell/7/pwsh \
    && ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh \
    && rm powershell.tar.gz \
    # Verify installations
    && echo "Node.js version:" && node --version \
    && echo "npm version:" && npm --version \
    && echo "PowerShell version:" && pwsh --version \
    && echo "Target architecture: $TARGETARCH" \
    # Clean up
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
