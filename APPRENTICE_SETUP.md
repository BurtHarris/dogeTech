# 👋 Apprentice Quick Setup Guide

## What You're Getting
A **safe experimental environment** for learning Node.js, TypeScript, and GitHub Copilot. Everything runs in a container, so you can't break your Surface laptop while experimenting!

## 🚀 One-Time Setup (30 minutes)

### Step 1: Install Required Software
1. **Docker Desktop**: [Download here](https://www.docker.com/products/docker-desktop/)
   - Choose "Windows" version
   - Install and restart your computer
   - Open Docker Desktop (it needs to be running)

2. **VS Code**: [Download here](https://code.visualstudio.com/) (if you don't have it)

3. **Dev Containers Extension**:
   - Open VS Code
   - Press `Ctrl+Shift+X` (Extensions)
   - Search for "Dev Containers"
   - Install the one by Microsoft

### Step 2: Get the Project
```powershell
# Open PowerShell and run:
git clone https://github.com/BurtHarris/dogeTech.git
cd dogeTech
code .
```

### Step 3: Open in Container
- VS Code will show a popup: **"Reopen in Container"**
- Click it!
- Wait 5-10 minutes for first build (downloads everything)
- You'll see: "🚀 DogeTech Experimental Dev Container Ready!"

## ✅ You're Ready!

### Test It Works
In the VS Code terminal (should be PowerShell):
```powershell
node --version     # Should show Node.js version
npm --version      # Should show npm version
pwsh --version     # Should show PowerShell version
```

### Try Your First Experiment
1. Edit `src/index.ts` in VS Code
2. Add some code (GitHub Copilot will help!)
3. Run it: `npm run dev`
4. Visit `http://localhost:3000` in your browser

## 🤝 Working Together

### Getting Updates
When your mentor adds new tools or fixes:
```powershell
git pull
# Then in VS Code: Ctrl+Shift+P → "Dev Containers: Rebuild Container"
```

### Sharing Your Work
```powershell
git add .
git commit -m "Description of what you built"
git push
```

## 🆘 If Something Goes Wrong

### Container Won't Start
```powershell
# Try rebuilding:
# In VS Code: Ctrl+Shift+P → "Dev Containers: Rebuild Container"
```

### VS Code Won't Connect
1. Close VS Code completely
2. Open PowerShell in the dogeTech folder
3. Run: `code .`
4. Click "Reopen in Container" again

### Docker Issues
1. Make sure Docker Desktop is running (icon in system tray)
2. Restart Docker Desktop
3. Try the container again

## 💡 What You Can Experiment With

- **Node.js/TypeScript projects**
- **GitHub Copilot AI assistance**
- **Web APIs and servers**
- **Any experimental code safely**

The container is your **safe playground** - you can't break anything on your Surface laptop!

## 📞 Getting Help

- Check the other docs in the `docs/` folder
- Ask your mentor (they have the exact same setup)
- Remember: if all else fails, you can always rebuild the container fresh

**Happy experimenting!** 🚀