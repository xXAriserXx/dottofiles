# Dottofiles Setup Guide (LLM Auto-Installer)

This guide is designed for an AI agent (like Gemini CLI, Claude, or GitHub Copilot) to automatically restore these configurations on a new macOS machine.

## Repository Contents
This folder contains configuration files (dotfiles) for:
- **Zsh**: `.zshrc`, `.zprofile`, `.zshenv`
- **Shell Theme**: `.p10k.zsh` (Powerlevel10k)
- **Git**: `.gitconfig`
- **Terminal**: `.wezterm.lua` (WezTerm)

---

## 🚀 Restoration Instructions

If you are an LLM assistant, please follow these steps to restore the environment:

### 1. Identify the dotfiles directory
Ensure you are running inside the `dottofiles` directory.

### 2. Symlink the files
Create symbolic links from the home directory to these files. Use the following command:

```bash
cd ~/dottofiles
for item in .zshrc .zprofile .zshenv .p10k.zsh .gitconfig .wezterm.lua; do
  # Backup existing files if they are not symlinks
  if [ -e ~/"$item" ] && [ ! -L ~/"$item" ]; then
    mv ~/"$item" ~/"$item.bak"
  fi
  # Create the symlink
  ln -sfn "$(pwd)/$item" ~/"$item"
done
```

### 3. Install Core Dependencies
Many of these configurations depend on the following tools. Install them via Homebrew:

```bash
# Install Homebrew if not present
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install core tools
brew install nvm nvim tmux fzf ripgrep
brew install --cask wezterm visual-studio-code
```

### 4. Install Fonts
The WezTerm and P10k configurations require **MesloLGS Nerd Font**.
Download and install the 4 TTF files from the [Powerlevel10k GitHub](https://github.com/romkatv/powerlevel10k#manual-font-installation).

### 5. Finalize Zsh
Restart the shell to apply changes:
```bash
source ~/.zshrc
```

---

## 🛠 Maintenance
To add a new config file to this setup:
1. Move the file into this directory: `mv ~/.newconfig ~/dottofiles/`
2. Create a symlink: `ln -s ~/dottofiles/.newconfig ~/.newconfig`
3. Update this `llm.md` if necessary.
