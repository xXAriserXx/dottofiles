local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_padding_left = 0

-- Remap movement keys from hjkl to jkl;
map('n', 'j', 'h', opts)
map('n', 'k', 'j', opts)
map('n', 'l', 'k', opts)
map('n', ';', 'l', opts)

-- Also do it for visual mode if you want
map('v', 'j', 'h', opts)
map('v', 'k', 'j', opts)
map('v', 'l', 'k', opts)
map('v', ';', 'l', opts)

