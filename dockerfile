# Use an official Node.js LTS image
FROM node:20-slim AS base

# Install development tools and utilities
RUN apt-get update && apt-get install -y \
    git \
    curl \
    vim \
    nano \
    procps \
    htop \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /usr/src/app

# Copy package files first (for better caching)
COPY package*.json tsconfig.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the source code
COPY . .

# Build TypeScript to JavaScript
RUN npm run build

# --- Production stage ---
FROM node:20-slim AS production

WORKDIR /usr/src/app

# Copy only built files and necessary metadata
COPY --from=base /usr/src/app/dist ./dist
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production

# Expose application port
EXPOSE 3000

# Start the app
CMD ["node", "dist/index.js"]
