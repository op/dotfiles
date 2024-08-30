-- Keybindings
--
-- Default keymaps that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local Util = require("lazyvim.util")

-- stylua: ignore
vim.keymap.set("n", "<leader>uL", function() Util.toggle("list") end, { desc = "Toggle List" })

-- remap lazy to <leader>z from <leader>l
vim.keymap.del("n", "<leader>l")
vim.keymap.set("n", "<leader>z", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- CTRL-W {h,j,k,l} works fine for moving to different windows
vim.keymap.del("n", "<C-h>")
vim.keymap.del("n", "<C-j>")
vim.keymap.del("n", "<C-k>")
vim.keymap.del("n", "<C-l>")

-- 'gq' is broken in recent versions of neovim + null-ls
-- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1131#issuecomment-1457584752
--
-- Restore 'gw' to default behavior. First, remove the 'gw' keymap set in LazyVim:
--vim.keymap.del({ "n", "x" }, "gw")
-- Then, reset formatexpr if null-ls is not providing any formatting generators.
-- See: https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1131
Util.lsp.on_attach(function(client, buf)
  if client.name == "null-ls" then
    if not require("null-ls.generators").can_run(vim.bo[buf].filetype, require("null-ls.methods").lsp.FORMATTING) then
      vim.bo[buf].formatexpr = nil
    end
  end
end)
