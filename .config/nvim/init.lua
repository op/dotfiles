-- Native-first Neovim (>= 0.12) config. See README.md for the security model.
--
-- Plugins:   vim.pack, pinned in nvim-pack-lock.json (lua/config/plugins.lua)
-- LSP:       vim.lsp.config/enable with configs in lsp/*.lua; servers from nix
-- Grammars:  tree-sitter parsers + queries from nix (share/nvim/site)

-- Space as leader (what the LazyVim setup effectively used); local leader
-- stays at the default \. Must be set before any mapping is defined.
vim.g.mapleader = " "

require("config.security") -- first: hardening must apply before anything loads files
require("config.options")
require("config.plugins")
require("config.treesitter")
require("config.lsp")
require("config.statusline")
require("config.keymaps")
require("config.autocmds")
