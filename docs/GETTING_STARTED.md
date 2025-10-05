# 🎯 Getting Started with DogeTech Dev Container

## What This Is
A **safe playground** for experimenting with Node.js, TypeScript, and GitHub Copilot. Your code stays on Windows, but runs in an isolated Ubuntu container.

## 🚦 First Time Setup

### 1. Install Requirements
- **Docker Desktop**: [Download](https://www.docker.com/products/docker-desktop/) and install
- **VS Code**: [Download](https://code.visualstudio.com/) if you don't have it
- **Dev Containers Extension**: Open VS Code → Extensions → Search "Dev Containers" → Install

### 2. Open This Project
```powershell
# In PowerShell or Command Prompt:
cd d:\dogeTech
code .
```

### 3. Start the Container
VS Code will show a popup in the bottom-right:
**"Reopen in Container"** → Click it!

*If you miss the popup:*
- Press `Ctrl+Shift+P`
- Type "reopen in container"
- Select "Dev Containers: Reopen in Container"

### 4. Wait for Setup (First time only)
- Container builds (5-10 minutes first time)
- Dependencies install automatically
- VS Code connects to container
- You'll see "DogeTech Experimental Dev Container Ready!" message

## ✅ You're Ready!

### Your Terminal
- Press `Ctrl+Shift+`` ` to open terminal
- You're now in **PowerShell inside the Ubuntu container**
- Try: `node --version`, `npm --version`, `pwsh --version`

### Your Files
- Edit files normally in VS Code (they're still on Windows)
- Changes appear instantly in the container
- IntelliSense, debugging, extensions all work normally

### GitHub Copilot
- Already enabled and ready to use
- Start typing code and Copilot will suggest completions
- Use `Ctrl+I` for Copilot Chat

## 🧪 Try Some Experiments

### Install a Package
```powershell
npm install express
```

### Create a Simple Server
Edit `src/index.ts`:
```typescript
import express from 'express';

const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Hello from DogeTech container!');
});

app.listen(port, '0.0.0.0', () => {
  console.log(`🚀 Server running at http://localhost:${port}`);
});
```

### Run It
```powershell
npm run dev
```

Visit `http://localhost:3000` in your browser!

## 💡 Key Points

- **Safe**: Nothing can harm your Windows machine
- **Isolated**: Each project gets its own container
- **Consistent**: Same environment every time
- **Easy**: Just edit files normally in VS Code
- **Powerful**: Full Ubuntu environment with all tools

## 🆘 Need Help?

- **Container won't start**: Try `npm run container:rebuild`
- **VS Code disconnected**: Close VS Code, reopen the folder, "Reopen in Container"
- **Files not syncing**: Make sure you opened VS Code in the `dogeTech` folder

Happy experimenting! 🚀