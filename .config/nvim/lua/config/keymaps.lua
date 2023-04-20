-- Keybindings
--
-- Default keymaps that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local Util = require("lazyvim.util")

-- stylua: ignore
vim.keymap.set("n", "<leader>uL", function() Util.toggle("list") end, { desc = "Toggle List" })
