This is a dotfiles repo. All config files are symlinked from here to their system locations.

## Structure

- `zshrc` → `~/.zshrc` — Shell config, aliases, PATH, prompt setup
- `gitconfig` → `~/.gitconfig` — Git user identity
- `wezterm.lua` → `~/.wezterm.lua` — Terminal emulator config
- `aerospace.toml` — Tiling window manager (AeroSpace); Preview opens floating, stretched to full width by `aerospace-fullwidth.js` (needs AeroSpace accessibility permission)
- `p10k.zsh` — Powerlevel10k prompt theme
- `nvim/` — Neovim config
- `yazi/` → `~/.config/yazi/` (yazi.toml, keymap.toml, imgview symlinked one by one) — Terminal file manager; Enter opens files with the same viewers as the `op` function (images full-window in the terminal via `yazi/imgview`, a zoom/pan viewer: kitty image protocol when available — needs `enable_kitty_graphics` in wezterm.lua — else iTerm2 inline images; never Preview.app); movement is jkl; instead of hjkl
- `karabiner/` — Keyboard remapping rules (machine-specific, see below); in Preview, `j`/`;` cycle Preview windows on the current AeroSpace workspace via `preview-cycle.sh`
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

Karabiner does not notice edits to the symlinked file. After editing, reload it: `launchctl kickstart -k gui/$(id -u)/org.pqrs.service.agent.Karabiner-Console-User-Server` (check `~/.local/share/karabiner/log/console_user_server.log` for a new "Load ..." line).
