This is a dotfiles repo. All config files are symlinked from here to their system locations.

## Structure

- `zshrc` → `~/.zshrc` — Shell config, aliases, PATH, prompt setup
- `gitconfig` → `~/.gitconfig` — Git user identity
- `wezterm.lua` → `~/.wezterm.lua` — Terminal emulator config
- `aerospace.toml` — Tiling window manager (AeroSpace)
- `p10k.zsh` — Powerlevel10k prompt theme
- `nvim/` — Neovim config
- `karabiner/` — Keyboard remapping rules (machine-specific, see below)
- `zprofile`, `zshenv` — Shell env setup (zshenv is empty)
- `llm.md` — LLM-related notes
- `SETUP_LOG.md` — Machine bootstrap steps

## Rules

- Files are symlinked, not copied. Edit them here, not at the system path.
- Never commit secrets (tokens, credentials, API keys). Check `.gitignore` before adding new config dirs.
- `zshrc` is organized into commented `# ===` sections (env, navigation, projects, dev, docker, k8s, git, tmux, editors, media, audio, URLs, misc, functions). Add new aliases inside the matching section; functions live at the bottom, after the aliases they use.
- Test alias changes with `source ~/.zshrc` before committing.
- After making changes, always: `git pull --rebase`, commit, and push. If there are merge conflicts, stop and ask before resolving.

## Karabiner (machine-specific)

There are two different Karabiner configs for two different machines. Symlink the correct one to `~/.config/karabiner/karabiner.json`:

- `karabiner/karabiner-apple.json` — for the machine with an Apple Magic Keyboard (vendor 1452, product 641). Has a device-specific rule swapping `left_command` → `left_option`.
- `karabiner/karabiner-other.json` — for the other machine, no device-specific overrides.

To set up on a new machine: `ln -sf ~/Documents/dottofiles/karabiner/karabiner-<machine>.json ~/.config/karabiner/karabiner.json`
