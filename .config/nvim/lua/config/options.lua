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

-- Clipboard in SSH session.
--
-- If OSC 52 is used as a fallback, copy will still not work unless we set a
-- clipboard.
vim.opt.clipboard = "unnamedplus" -- Clipboard for all interactions
--
-- Since we now have set clipboard, Neovim will not make use of OSC 52. Hence
-- we need to explicitly set g.clipboard.
--
-- Alacritty has paste turned off for good reasons. We still need to set the
-- paste action to something, or the g.clipboard will be invalid / not used.
--
-- This also forces nvim to make use of OSC 52 even if within tmux. This
-- requires tmux 0.3.3 (and `tmux set -s set-clipboard on`).
--
-- References:
-- * https://gpanders.com/blog/whats-new-in-neovim-0.10/#system-clipboard-synchronization
-- * https://alacritty.org/config-alacritty.html#terminal
-- * https://github.com/neovim/neovim/issues/29504
-- * https://github.com/neovim/neovim/discussions/28010
if vim.env.SSH_TTY then
  -- Set paste to behave like normal paste
  local function paste()
    return {
      vim.fn.split(vim.fn.getreg(""), "\n"),
      vim.fn.getregtype(""),
    }
  end
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = paste,
      ["*"] = paste,
    },
  }
end

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

-- Set to "bacon-ls" to use bacon-ls instead of rust-analyzer for diagnostics.
-- The rest of LSP support will still be provided by rust-analyzer.
-- vim.g.lazyvim_rust_diagnostics = "bacon-ls"

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

-- disable some bells and whistles
vim.g.snacks_animate = false
vim.g.smoothscroll = false

-- Follow color scheme from GNOME
local color_scheme = vim.fn.system("gsettings get org.gnome.desktop.interface color-scheme")
if string.find(color_scheme, "dark") then
  vim.o.background = "dark"
elseif vim.fn.filereadable(vim.fn.expand("~/.darkmode")) == 1 then
  vim.o.background = "dark"
else
  vim.o.background = "light"
end

--
-- LazyVim
--
-- vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"
-- disable automatic insertion of pairs like parenthesis etc
vim.g.minipairs_disable = true

-- Use telescope instead of fzf since it has venv-selector
-- https://github.com/LazyVim/LazyVim/issues/4113
-- vim.g.lazyvim_picker = "telescope"
