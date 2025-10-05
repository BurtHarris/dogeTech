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
    # Install shell enhancement tools for better Windows dev experience
    && apt-get install -y zsh fish \
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

# Configure better shell experience for Windows developers
RUN echo '# Windows-friendly bash configuration' > /etc/bash.bashrc.local \
    && echo 'export HISTCONTROL=ignoredups:erasedups' >> /etc/bash.bashrc.local \
    && echo 'export HISTSIZE=10000' >> /etc/bash.bashrc.local \
    && echo 'export HISTFILESIZE=10000' >> /etc/bash.bashrc.local \
    && echo 'shopt -s histappend' >> /etc/bash.bashrc.local \
    && echo 'shopt -s checkwinsize' >> /etc/bash.bashrc.local \
    && echo 'bind "set completion-ignore-case on"' >> /etc/bash.bashrc.local \
    && echo 'bind "set show-all-if-ambiguous on"' >> /etc/bash.bashrc.local \
    && echo 'bind "set completion-map-case on"' >> /etc/bash.bashrc.local \
    && echo '' >> /etc/bash.bashrc.local \
    && echo '# Windows-friendly aliases' >> /etc/bash.bashrc.local \
    && echo 'alias ll="ls -la"' >> /etc/bash.bashrc.local \
    && echo 'alias la="ls -la"' >> /etc/bash.bashrc.local \
    && echo 'alias cls="clear"' >> /etc/bash.bashrc.local \
    && echo 'alias dir="ls -la"' >> /etc/bash.bashrc.local \
    && echo 'alias type="cat"' >> /etc/bash.bashrc.local \
    && echo 'alias copy="cp"' >> /etc/bash.bashrc.local \
    && echo 'alias move="mv"' >> /etc/bash.bashrc.local \
    && echo 'alias del="rm"' >> /etc/bash.bashrc.local \
    && echo 'alias md="mkdir"' >> /etc/bash.bashrc.local \
    && echo 'alias rd="rmdir"' >> /etc/bash.bashrc.local \
    && echo '' >> /etc/bash.bashrc.local \
    && echo '# PowerShell shortcut' >> /etc/bash.bashrc.local \
    && echo 'alias ps="pwsh"' >> /etc/bash.bashrc.local \
    && echo 'alias powershell="pwsh"' >> /etc/bash.bashrc.local \
    && echo '' >> /etc/bash.bashrc.local \
    && echo '# Development shortcuts' >> /etc/bash.bashrc.local \
    && echo 'alias build="npm run build"' >> /etc/bash.bashrc.local \
    && echo 'alias dev="npm run dev"' >> /etc/bash.bashrc.local \
    && echo 'alias test="npm test"' >> /etc/bash.bashrc.local \
    && echo 'alias start="npm start"' >> /etc/bash.bashrc.local \
    && echo '' >> /etc/bash.bashrc.local \
    && echo '# Load local config' >> /etc/bash.bashrc.local \
    && echo 'source /etc/bash.bashrc.local 2>/dev/null || true' >> /etc/bash.bashrc \
    # Create PowerShell profile for container use
    && mkdir -p /opt/microsoft/powershell/7/profile \
    && echo '# PowerShell profile for DogeTech development container' > /opt/microsoft/powershell/7/profile/Microsoft.PowerShell_profile.ps1 \
    && echo '# Windows-friendly aliases' >> /opt/microsoft/powershell/7/profile/Microsoft.PowerShell_profile.ps1 \
    && echo 'Set-Alias -Name cls -Value Clear-Host' >> /opt/microsoft/powershell/7/profile/Microsoft.PowerShell_profile.ps1 \
    && echo 'Set-Alias -Name dir -Value Get-ChildItem' >> /opt/microsoft/powershell/7/profile/Microsoft.PowerShell_profile.ps1 \
    && echo 'Set-Alias -Name type -Value Get-Content' >> /opt/microsoft/powershell/7/profile/Microsoft.PowerShell_profile.ps1 \
    && echo 'Set-Alias -Name copy -Value Copy-Item' >> /opt/microsoft/powershell/7/profile/Microsoft.PowerShell_profile.ps1 \
    && echo 'Set-Alias -Name move -Value Move-Item' >> /opt/microsoft/powershell/7/profile/Microsoft.PowerShell_profile.ps1 \
    && echo 'Set-Alias -Name del -Value Remove-Item' >> /opt/microsoft/powershell/7/profile/Microsoft.PowerShell_profile.ps1 \
    && echo 'Set-Alias -Name md -Value New-Item -Option AllScope' >> /opt/microsoft/powershell/7/profile/Microsoft.PowerShell_profile.ps1 \
    && echo '' >> /opt/microsoft/powershell/7/profile/Microsoft.PowerShell_profile.ps1 \
    && echo '# Development shortcuts' >> /opt/microsoft/powershell/7/profile/Microsoft.PowerShell_profile.ps1 \
    && echo 'function build { npm run build }' >> /opt/microsoft/powershell/7/profile/Microsoft.PowerShell_profile.ps1 \
    && echo 'function dev { npm run dev }' >> /opt/microsoft/powershell/7/profile/Microsoft.PowerShell_profile.ps1 \
    && echo 'function test { npm test }' >> /opt/microsoft/powershell/7/profile/Microsoft.PowerShell_profile.ps1 \
    && echo 'function start { npm start }' >> /opt/microsoft/powershell/7/profile/Microsoft.PowerShell_profile.ps1 \
    && echo '' >> /opt/microsoft/powershell/7/profile/Microsoft.PowerShell_profile.ps1 \
    && echo '# Welcome message' >> /opt/microsoft/powershell/7/profile/Microsoft.PowerShell_profile.ps1 \
    && echo 'Write-Host "🐕 Welcome to DogeTech Development Container!" -ForegroundColor Green' >> /opt/microsoft/powershell/7/profile/Microsoft.PowerShell_profile.ps1 \
    && echo 'Write-Host "💡 Tip: Use familiar Windows commands like dir, cls, type, etc." -ForegroundColor Cyan' >> /opt/microsoft/powershell/7/profile/Microsoft.PowerShell_profile.ps1 \
    && echo 'Write-Host "🚀 Quick dev commands: build, dev, test, start" -ForegroundColor Yellow' >> /opt/microsoft/powershell/7/profile/Microsoft.PowerShell_profile.ps1 \
    && echo '' >> /opt/microsoft/powershell/7/profile/Microsoft.PowerShell_profile.ps1 \
    # Set up readline configuration for better key bindings
    && echo '"\e[A": history-search-backward' > /etc/inputrc.local \
    && echo '"\e[B": history-search-forward' >> /etc/inputrc.local \
    && echo '"\e[C": forward-char' >> /etc/inputrc.local \
    && echo '"\e[D": backward-char' >> /etc/inputrc.local \
    && echo 'set completion-ignore-case on' >> /etc/inputrc.local \
    && echo 'set show-all-if-ambiguous on' >> /etc/inputrc.local \
    && echo 'set completion-map-case on' >> /etc/inputrc.local \
    && echo 'set colored-stats on' >> /etc/inputrc.local \
    && echo 'set visible-stats on' >> /etc/inputrc.local \
    && echo 'set mark-symlinked-directories on' >> /etc/inputrc.local \
    && echo '$include /etc/inputrc.local' >> /etc/inputrc

# Development stage - includes dev tools and doesn't build
# Note: Source code is bind-mounted at runtime, not copied during build
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
FROM ubuntu:22.04 AS production

# Install Node.js 20 LTS for production
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

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
