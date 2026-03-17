-- Set leader key (optional, but recommended)
vim.g.mapleader = " "

-- Remap hjkl to jkl; for navigation
-- Syntax: vim.keymap.set(mode, new_key, original_function, options)

-- j = Left (formerly h)
vim.keymap.set({'n', 'v'}, 'j', 'h', { noremap = true })

-- k = Down (formerly j)
vim.keymap.set({'n', 'v'}, 'k', 'j', { noremap = true })

-- l = Up (formerly k)
vim.keymap.set({'n', 'v'}, 'l', 'k', { noremap = true })

-- ; = Right (formerly l)
vim.keymap.set({'n', 'v'}, ';', 'l', { noremap = true })

-- Since 'h' is now free, let's map it to the old ';' 
-- (Repeat last f, F, t, or T search)
vim.keymap.set({'n', 'v'}, 'h', ';', { noremap = true })

-- Set transparency to match WezTerm
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

