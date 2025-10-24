# Clash Cheese's Project: Meeting Yourself — Deployment Guide

This document outlines how to deploy and run the **Clash Cheese Project Adventure** text-based game built with **Godot**.

---

## 🚀 Requirements

- **Godot Engine:** v4.x (specify exact version if needed)
- **Git:** v2.x or later  
- **Operating System:** Windows / macOS / Linux  
- *(Optional)* A web export preset configured for HTML5 builds  



## 📦 Cloning the Repository

```bash
git clone https://github.com/SamiAchnine/clash-cheese-project-adventure.git
cd clash-cheese-project-adventure
```


## 🧩 Opening the Project in Godot
 1) Open the Godot Editor.
 2) Click Import → Browse and select the project.godot file inside the cloned repository folder.
 3) Press Import & Edit.



## ▶️ Running the Game (Development)
 1) In Godot, click the Play button or press <kbd>F5</kbd>.
 2) The game should launch in the default scene specified in the project.godot file.



## 🌐 Building for Deployment
 1) Web (HTML5)
 2) In Godot, go to Project → Export → Add... → Web (HTML5).
 3) Configure the export settings (output folder, compression, etc.).
 4) Click Export Project.
 5) The exported build will include:
```diff
index.html
clash_cheese_project_adventure.pck
clash_cheese_project_adventure.wasm
```
You can host these on GitHub Pages, Itch.io, or any static web host.



## 💾 Deployment Example (GitHub Pages)
If exporting to HTML5 and deploying on GitHub Pages:
 1) Commit your exported build to a gh-pages branch.
 2) In your repository, go to Settings → Pages.
 3) Set the source to gh-pages and save.
Access your game at:
```
https://<username>.github.io/clash-cheese-project-adventure/
```


## 🧹 Troubleshooting
 - If Godot reports missing assets, ensure the res:// paths in scenes/scripts are valid.
 - Clear .import/ if build artifacts become corrupted.
 - Verify your Godot version matches the version used for development.



## 📚 Additional Notes
 - Story written by Alexander Frieders
 - Visuals done by Sami Achnine
 - 95% of the programming done by ChatGPT
 - As this game has a lot of AI generated content, this project has no copyright whatsoever. Any takedown notice from using this project's code or assets is not from the original developers of this codebase.