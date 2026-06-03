This is a dotfiles repo. All config files are symlinked from here to their system locations.

## Structure

- `zshrc` → `~/.zshrc` — Shell config, aliases, PATH, prompt setup
- `gitconfig` → `~/.gitconfig` — Git user identity
- `wezterm.lua` → `~/.wezterm.lua` — Terminal emulator config
- `aerospace.toml` — Tiling window manager (AeroSpace)
- `p10k.zsh` — Powerlevel10k prompt theme
- `nvim/` — Neovim config
- `karabiner/` — Keyboard remapping rules
- `zprofile`, `zshenv` — Shell env setup (zshenv is empty)
- `llm.md` — LLM-related notes
- `SETUP_LOG.md` — Machine bootstrap steps

## Rules

- Files are symlinked, not copied. Edit them here, not at the system path.
- Never commit secrets (tokens, credentials, API keys). Check `.gitignore` before adding new config dirs.
- `zshrc` is large (~600 lines). Keep aliases grouped by project/tool. Git aliases are near line 155, blor aliases near line 560.
- Test alias changes with `source ~/.zshrc` before committing.
