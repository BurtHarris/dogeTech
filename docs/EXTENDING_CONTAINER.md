# 🔧 Extending Your Dev Container: Practical Guide

## Overview
Your dogeTech container is designed to grow with your needs. This guide shows you exactly how to add new tools, languages, and capabilities.

## 🎯 Basic Extension Pattern

### The Process (Same Every Time)
1. **Modify** the Dockerfile to add new tools
2. **Rebuild** the container
3. **Test** the new functionality
4. **Document** what you added

### Key Files to Know
- **`dockerfile`**: Defines what's installed in your container
- **`.devcontainer/devcontainer.json`**: Configures VS Code integration
- **`docker-compose.yml`**: Manages container networking and volumes
- **`package.json`**: Node.js dependencies and scripts

## 🐍 Example 1: Adding Python

### Step 1: Modify Dockerfile
Add this after the existing Node.js installation:

```dockerfile
# Add Python 3 and common data science packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    && pip3 install --upgrade pip \
    && pip3 install \
        pandas \
        numpy \
        matplotlib \
        jupyter \
        requests \
        flask
```

### Step 2: Update VS Code Configuration
Edit `.devcontainer/devcontainer.json` to add Python extensions:

```json
"extensions": [
  "ms-vscode.vscode-typescript-next",
  "GitHub.copilot",
  "GitHub.copilot-chat",
  "ms-python.python",           // Add this
  "ms-python.pylint",           // Add this
  "ms-toolsai.jupyter",         // Add this
  "ms-vscode.powershell"
]
```

### Step 3: Rebuild Container
```powershell
npm run container:rebuild
```

### Step 4: Test Python
Open VS Code terminal in container:
```powershell
python3 --version
pip3 list
jupyter --version
```

## 🌐 Example 2: Adding SvelteKit

### Step 1: Add Global Tools
Edit `dockerfile`:

```dockerfile
# Add SvelteKit and modern web development tools
RUN npm install -g \
    @sveltejs/kit \
    vite \
    playwright \
    @playwright/test
```

### Step 2: Update Package.json
Add SvelteKit to your project dependencies:

```json
{
  "devDependencies": {
    "@sveltejs/adapter-auto": "^2.0.0",
    "@sveltejs/kit": "^1.20.4",
    "svelte": "^4.0.5",
    "vite": "^4.4.2"
  }
}
```

### Step 3: Add VS Code Extensions
```json
"extensions": [
  "svelte.svelte-vscode",       // Add this
  "bradlc.vscode-tailwindcss",  // Already included
  "ms-playwright.playwright"    // Add this
]
```

### Step 4: Create SvelteKit Project
```powershell
npm create svelte@latest my-app
cd my-app
npm install
npm run dev
```

## 🗄️ Example 3: Adding Database Support

### Step 1: Add Database to Docker Compose
Edit `docker-compose.yml`:

```yaml
services:
  app-dev:
    # ... existing configuration ...
    depends_on:
      - database
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgresql://dev:dev@database:5432/devdb

  database:
    image: postgres:15
    environment:
      POSTGRES_USER: dev
      POSTGRES_PASSWORD: dev
      POSTGRES_DB: devdb
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

volumes:
  vscode-server:
  postgres_data:    # Add this
```

### Step 2: Add Database Tools to Container
Edit `dockerfile`:

```dockerfile
# Add PostgreSQL client tools
RUN apt-get update && apt-get install -y \
    postgresql-client \
    && npm install -g \
        prisma \
        @prisma/client
```

### Step 3: Test Database Connection
```powershell
# Connect to database from container
psql -h database -U dev -d devdb

# Or use Node.js
npm install pg @types/pg
```

## 🤖 Example 4: Adding AI/ML Tools

### Step 1: Add Python ML Stack
```dockerfile
# Add comprehensive ML environment
RUN pip3 install \
    tensorflow \
    torch \
    transformers \
    scikit-learn \
    opencv-python \
    pillow \
    streamlit
```

### Step 2: Add Jupyter Configuration
```dockerfile
# Configure Jupyter for container use
RUN jupyter notebook --generate-config \
    && echo "c.NotebookApp.ip = '0.0.0.0'" >> ~/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.allow_root = True" >> ~/.jupyter/jupyter_notebook_config.py
```

### Step 3: Add Port for Jupyter
Edit `docker-compose.yml`:
```yaml
ports:
  - "3000:3000"   # Application server
  - "9229:9229"   # Node.js debug port  
  - "8888:8888"   # Jupyter notebook
```

## 🔨 Extension Templates

### Template 1: Add Programming Language
```dockerfile
# Add [LANGUAGE] support
RUN apt-get update && apt-get install -y \
    [language-specific-packages] \
    && [language-specific-setup-commands]
```

### Template 2: Add Global CLI Tools
```dockerfile  
RUN npm install -g \
    [tool1] \
    [tool2] \
    [tool3]
```

### Template 3: Add System Dependencies
```dockerfile
RUN apt-get update && apt-get install -y \
    [system-package-1] \
    [system-package-2] \
    && rm -rf /var/lib/apt/lists/*
```

## 🚀 Advanced Extension Ideas

### Development Tools
```dockerfile
# Add advanced development tools
RUN npm install -g \
    @angular/cli \
    create-react-app \
    vue-cli \
    gatsby-cli \
    next \
    express-generator
```

### DevOps Tools
```dockerfile  
# Add DevOps and cloud tools
RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh \
    && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl && mv kubectl /usr/local/bin/
```

### Data Science Stack
```dockerfile
# Add comprehensive data science environment
RUN pip3 install \
    scipy \
    seaborn \
    plotly \
    dash \
    streamlit \
    poetry \
    black \
    isort
```

## 🎯 Best Practices

### 1. **Layer Efficiently**
```dockerfile
# Good: Combine related installs
RUN apt-get update && apt-get install -y \
    tool1 tool2 tool3 \
    && rm -rf /var/lib/apt/lists/*

# Bad: Multiple RUN commands
RUN apt-get update
RUN apt-get install -y tool1
RUN apt-get install -y tool2
```

### 2. **Clean Up After Installs**
```dockerfile
RUN apt-get update && apt-get install -y packages \
    && rm -rf /var/lib/apt/lists/*  # This saves space
```

### 3. **Pin Versions for Stability**
```dockerfile
# Good: Specific versions
RUN pip3 install pandas==1.5.3 numpy==1.24.3

# Risky: Latest versions (may break later)
RUN pip3 install pandas numpy
```

### 4. **Test Before Committing**
Always test new additions:
```powershell
# Rebuild and test
npm run container:rebuild
# Test your new tools work
python3 --version
node --version  
your-new-tool --version
```

## 🐛 Troubleshooting Extensions

### Container Won't Build
```powershell
# Try building with no cache
docker system prune
npm run container:rebuild
```

### New Tool Not Found
```powershell
# Check if it was actually installed
docker-compose exec app-dev which your-tool
docker-compose exec app-dev ls /usr/local/bin
```

### VS Code Extensions Not Working
1. Check `.devcontainer/devcontainer.json` syntax
2. Restart VS Code
3. "Dev Containers: Rebuild Container"

## 💡 Next Steps

1. **Start Simple**: Pick one extension that interests you
2. **Follow the Pattern**: Modify Dockerfile → Rebuild → Test
3. **Document Changes**: Note what you added for future reference
4. **Share with Apprentice**: Your extended container works for them too!

Your container is now a **growing toolkit** that evolves with your learning and projects. Start with what interests you most!