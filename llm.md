# Dottofiles Setup Guide (LLM Auto-Installer)

This guide is designed for an AI agent (like Gemini CLI, Claude, or GitHub Copilot) to automatically restore these configurations on a new macOS machine.

## Repository Contents
This folder contains configuration files (dotfiles) for:
- **Zsh**: `zshrc`, `zprofile`, `zshenv`
- **Shell Theme**: `p10k.zsh` (Powerlevel10k)
- **Git**: `gitconfig`
- **Terminal**: `wezterm.lua` (WezTerm)
- **Karabiner**: `karabiner/karabiner.json` (Key mappings)
- **Aerospace**: `aerospace.toml` (Window manager)
- **Neovim**: `nvim/init.lua` (Neovim configuration)

---

## 🚀 Restoration Instructions

If you are an LLM assistant, please follow these steps to restore the environment:

### 1. Identify the dotfiles directory
Ensure you are running inside the `dottofiles` directory.

### 2. Symlink the files
Create symbolic links from the home directory to these files. Use the following command:

```bash
cd ~/dottofiles

# Standard dotfiles
for item in zshrc zprofile zshenv p10k.zsh gitconfig wezterm.lua aerospace.toml; do
  # Backup existing files if they are not symlinks
  if [ -e ~/."$item" ] && [ ! -L ~/."$item" ]; then
    mv ~/."$item" ~/."$item.bak"
  fi
  # Create the symlink (repo files are non-hidden, home dir symlinks have the dot prefix)
  ln -sfn "$(pwd)/$item" ~/."$item"
done

# Karabiner-Elements (Special handling: symlink the file, not the folder)
mkdir -p ~/.config/karabiner
if [ -e ~/.config/karabiner/karabiner.json ] && [ ! -L ~/.config/karabiner/karabiner.json ]; then
  mv ~/.config/karabiner/karabiner.json ~/.config/karabiner/karabiner.json.bak
fi
ln -sfn "$(pwd)/karabiner/karabiner.json" ~/.config/karabiner/karabiner.json

# Neovim (Special handling: symlink into ~/.config/nvim/)
mkdir -p ~/.config/nvim
if [ -e ~/.config/nvim/init.lua ] && [ ! -L ~/.config/nvim/init.lua ]; then
  mv ~/.config/nvim/init.lua ~/.config/nvim/init.lua.bak
fi
ln -sfn "$(pwd)/nvim/init.lua" ~/.config/nvim/init.lua
```

### 3. Install Prerequisites
These are the tools referenced across the dotfiles. Install them **before** symlinking so the shell can source everything cleanly.

```bash
# Install Homebrew if not present
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### 3a. Core CLI tools
```bash
brew install nvm neovim tmux fzf ripgrep jq pnpm gh
```

| Tool | Why it's needed |
|------|----------------|
| **nvm** | Node version manager — loaded in `zshrc` |
| **neovim** | Default `$EDITOR`, aliased as `n` |
| **tmux** | Terminal multiplexer — several `tms`/`tuni` aliases |
| **fzf** | Fuzzy finder |
| **ripgrep** | Fast grep replacement |
| **jq** | JSON processor — used by the `gcom()` AI-commit function |
| **pnpm** | Package manager — `ike`, `bd`, `pi` aliases |
| **gh** | GitHub CLI — `ghls` alias |

#### 3b. GUI applications
```bash
brew install --cask wezterm visual-studio-code docker karabiner-elements nikitabobko/tap/aerospace
```

| App | Why it's needed |
|-----|----------------|
| **WezTerm** | Primary terminal — configured by `wezterm.lua` |
| **Visual Studio Code** | Editor — aliased as `nv` (`code -n`) |
| **Docker** | Container runtime — `dcu`, `dcublor` aliases and `start_zeus()` |
| **Karabiner-Elements** | Key remapping — configured by `karabiner/karabiner.json` |
| **AeroSpace** | Window manager — configured by `aerospace.toml` |

#### 3c. Zsh theme (Powerlevel10k)
```bash
brew install powerlevel10k
```
Sourced directly from `/opt/homebrew/share/powerlevel10k/` in `zshrc`.

#### 3d. Media & utility tools (optional)
These are used by various aliases. Install any you need:

```bash
brew install yt-dlp mpv blueutil switchaudio-osx
```

| Tool | Why it's needed |
|------|----------------|
| **yt-dlp** | YouTube downloader — `yt`, `ytm`, `ytmm` aliases |
| **mpv** | Media player — `mu` (audio), `vi` (video) aliases |
| **blueutil** | Bluetooth control — `blip`, `blco` aliases |
| **switchaudio-osx** | Audio output switching — `switch`, `switchMic`, `alexa` aliases |

### 4. Install Fonts
The WezTerm and P10k configurations require **MesloLGS Nerd Font Mono**.
Download and install the 4 TTF files from the [Powerlevel10k GitHub](https://github.com/romkatv/powerlevel10k#manual-font-installation).

Or via Homebrew:
```bash
brew install --cask font-meslo-lg-nerd-font
```

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
