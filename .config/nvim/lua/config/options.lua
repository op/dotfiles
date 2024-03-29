-- Default options that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Revert back to \ as leader
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

local opt = vim.opt

--
-- General
--
opt.confirm = false -- Revert back to vim default
opt.fixendofline = false -- Stop adding endlines
opt.mouse = "" -- Disable mouse
opt.scrolloff = 2 -- Show lines above and below cursor
opt.selectmode = "mouse,key"
opt.sidescrolloff = 2 -- Show columns left and right of cursor
opt.sidescroll = 1 -- Scroll whole page horizontally
opt.ttimeout = true
opt.ttimeoutlen = 50

--
-- File handling
--
opt.backup = true
opt.backupdir = { vim.fn.expand("~/.local/state/nvim/backup/") }
opt.undofile = true
opt.undolevels = 10240
vim.go.netrw_dirhistmax = 0
opt.fileencodings = "utf-8,default,latin1"

--
-- Indentation and formatting
--
opt.copyindent = true
opt.preserveindent = true
opt.breakindent = true

opt.joinspaces = false

opt.softtabstop = 2
opt.linebreak = true -- Soft wrap lines
opt.breakindent = true -- Visually indent lines that breaks
opt.cinoptions = ":0,g0,p2s,t0,+1s,(0"

---
--- Searching
---
opt.path:append("**")
opt.wildignore:append("*/tags,*/tmp/*,/var/*,*.a,*.o,*.obj,*.so,*.swp,*.zip,*.tar,*.pyc")
opt.wildmode = "list:longest,full"
opt.hlsearch = true

--
-- Completion
--
opt.completeopt = "menu,menuone,noinsert,noselect"

--
-- Appearance
--
opt.laststatus = 0
opt.list = false
opt.listchars = { eol = "↵", tab = "→ ", trail = "·" }
opt.colorcolumn = "80"
opt.number = false
opt.relativenumber = false

-- Follow color scheme from GNOME
local color_scheme = vim.fn.system("gsettings get org.gnome.desktop.interface color-scheme")
if string.find(color_scheme, "dark") then
  opt.background = "dark"
else
  opt.background = "light"
end
