-- Default options that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

--
-- General
--
vim.opt.confirm = false -- Revert back to vim default
vim.opt.fixendofline = false -- Stop adding endlines
vim.opt.mouse = "" -- Disable mouse
vim.opt.scrolloff = 2 -- Show lines above and below cursor
vim.opt.selectmode = "mouse,key"
vim.opt.sidescrolloff = 2 -- Show columns left and right of cursor
vim.opt.sidescroll = 1 -- Scroll whole page horizontally
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 50

--
-- File handling
--
vim.opt.backup = true
vim.opt.backupdir = { vim.fn.expand("~/.local/state/nvim/backup/") }
vim.opt.undofile = true
vim.opt.undolevels = 10240
--vim.go.netrw_dirhistmax = 0
vim.opt.fileencodings = "utf-8,default,latin1"

--
-- Indentation and formatting
--
vim.opt.copyindent = true
vim.opt.preserveindent = true
vim.opt.breakindent = true

vim.opt.joinspaces = false

vim.opt.softtabstop = 2
vim.opt.linebreak = true -- Soft wrap lines
vim.opt.breakindent = true -- Visually indent lines that breaks
vim.opt.cinoptions = ":0,g0,p2s,t0,+1s,(0"

---
--- Searching
---
vim.opt.path:append("**")
vim.opt.wildignore:append("*/tags,*/tmp/*,/var/*,*.a,*.o,*.obj,*.so,*.swp,*.zip,*.tar,*.pyc")
vim.opt.wildmode = "list:longest,full"
vim.opt.hlsearch = true

--
-- Completion
--
vim.opt.completeopt = "menu,menuone,noinsert,noselect"

--
-- LSP
--
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"

--
-- Appearance
--
vim.opt.cmdheight = 0
vim.opt.laststatus = 0
vim.opt.list = false
vim.opt.listchars = { eol = "↵", tab = "→ ", trail = "·" }
vim.opt.colorcolumn = "80"
vim.opt.number = false
vim.opt.relativenumber = false

-- Follow color scheme from GNOME
local color_scheme = vim.fn.system("gsettings get org.gnome.desktop.interface color-scheme")
if string.find(color_scheme, "dark") then
  vim.opt.background = "dark"
else
  vim.opt.background = "light"
end
