# Neovim Keymaps

Leader key: `Space`

## Search

- `<leader>ff` : find files
- `<C-r>` : quick file switch with Telescope file search
- `<leader>fg` : search text across the project with Telescope live grep
- `<leader>fb` : list open buffers
- `<leader>fh` : search help tags
- `<leader>fr` : search recent files
- `<leader>/` : fuzzy search inside the current buffer

## Git

- `<leader>gc` : search Git commits for the current repository
- `<leader>gb` : list Git branches for the current repository
- `<leader>gs` : show Git status for the current repository
- `<leader>hb` : show blame for the current line
- `<leader>hp` : preview the current Git hunk
- `<leader>hd` : diff the current file
- `<leader>hs` : stage the current hunk
- `<leader>hr` : reset the current hunk
- `]h` : jump to next Git hunk
- `[h` : jump to previous Git hunk

## LSP

- `gd` : go to definition
- `gr` : show references
- `K` : hover documentation
- `<leader>rn` : rename symbol
- `<leader>ca` : code action
- `<leader>e` : show diagnostics for the current line
- `[d` : jump to previous diagnostic
- `]d` : jump to next diagnostic

## Movement

Your movement keys are remapped from the standard Vim defaults:

- `j` : move left
- `k` : move down
- `l` : move up
- `;` : move right
- `h` : repeat the last `f`, `F`, `t`, or `T` search

## Editing

- Auto-pairs are enabled in insert mode for brackets and quotes
- Catppuccin Frappe is the active colorscheme
- Line numbers are enabled
- Relative line numbers are disabled
- Current line highlight is enabled

## Notes

- Git Telescope commands work from the repository of the current file, not from the parent `prod` directory
- Inline Git blame is disabled to avoid layout shift; use `<leader>hb` on demand
- CSV files use `csvview.nvim` for a structured view inside Neovim
- Your config is stored in `~/Documents/dottofiles/nvim/init.lua`
- Shell alias `ncom` opens this file directly
