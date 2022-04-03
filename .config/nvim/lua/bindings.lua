---
--- Keybindings
---
vim.api.nvim_set_keymap('n', '<leader>l', ':setlocal list! list?<cr>', { silent = true})
vim.api.nvim_set_keymap('n', '<leader>s', ':setlocal spell! spell?<cr>', { silent = true})
