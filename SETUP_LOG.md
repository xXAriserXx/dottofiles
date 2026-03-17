# Dottofiles Setup Log

This document records the installation and configuration steps performed to restore the environment from this repository.

## 📅 Last Updated: 2026-03-17

---

## 1. Prerequisites Installed

### Homebrew
Verified and used for all subsequent installations.

### Fonts
- **MesloLGS Nerd Font**: Installed via Homebrew for WezTerm and Powerlevel10k support.
  ```bash
  brew install --cask font-meslo-lg-nerd-font
  ```

---

## 2. Applications & Configurations Applied

### Terminal: WezTerm
- **Action**: Installed WezTerm and symlinked configuration.
- **Commands**:
  ```bash
  brew install --cask wezterm
  ln -sfn "$(pwd)/wezterm.lua" ~/.wezterm.lua
  ```

### Key Mapping: Karabiner-Elements
- **Action**: Installed Karabiner-Elements and symlinked configuration.
- **Commands**:
  ```bash
  brew install --cask karabiner-elements
  mkdir -p ~/.config/karabiner
  ln -sfn "$(pwd)/karabiner/karabiner.json" ~/.config/karabiner/karabiner.json
  ```

### Window Manager: AeroSpace
- **Action**: Installed AeroSpace (via Nikita Bobko's tap) and symlinked configuration.
- **Commands**:
  ```bash
  brew install --cask nikitabobko/tap/aerospace
  ln -sfn "$(pwd)/aerospace.toml" ~/.aerospace.toml
  ```

### Shell Theme: Powerlevel10k
- **Action**: Installed the Powerlevel10k Zsh theme and symlinked configuration.
- **Commands**:
  ```bash
  brew install powerlevel10k
  ln -sfn "$(pwd)/p10k.zsh" ~/.p10k.zsh
  ```

### Editor: Neovim
- **Action**: Copied Neovim configuration and symlinked it.
- **Commands**:
  ```bash
  mkdir -p ~/.config/nvim
  ln -sfn "$(pwd)/nvim/init.lua" ~/.config/nvim/init.lua
  ```

### Shell: Zsh
- **Action**: Symlinked core Zsh configuration files.
- **Commands**:
  ```bash
  for item in zshrc zprofile zshenv; do
    ln -sfn "$(pwd)/$item" ~/."$item"
  done
  ```

---

## 🛠 Backup Strategy
For every symlink created, if a physical file (not a symlink) already existed at the destination, it was moved to a `.bak` file (e.g., `~/.zshrc` -> `~/.zshrc.bak`) before the symlink was established.

## 🏁 Current Status
- [x] WezTerm Setup
- [x] Karabiner-Elements Setup
- [x] AeroSpace Setup
- [x] Powerlevel10k Setup
- [x] Zsh Setup
- [x] Neovim Setup
- [ ] Core CLI Tools (nvm, neovim, tmux, etc.)
- [ ] VS Code & Docker
- [ ] Media Tools (yt-dlp, mpv, etc.)
