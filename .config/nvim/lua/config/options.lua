--
-- General
--
vim.opt.confirm = false
vim.opt.fixendofline = false -- Stop adding endlines
vim.opt.mouse = "" -- Disable mouse
vim.opt.scrolloff = 2
vim.opt.sidescrolloff = 2
vim.opt.sidescroll = 1
vim.opt.selectmode = "mouse,key"
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 50
vim.opt.timeoutlen = 1000 -- time to finish a mapping like <leader>ghs (no which-key)
vim.opt.updatetime = 200
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen"
vim.opt.virtualedit = "block"
vim.opt.jumpoptions = "view"
vim.opt.inccommand = "nosplit"
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.showmode = false
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- Clipboard in SSH session.
--
-- If OSC 52 is used as a fallback, copy will still not work unless we set a
-- clipboard. (Disabled while a sensitive file is current, see security.lua.)
vim.opt.clipboard = "unnamedplus"
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
  local function paste()
    return {
      vim.fn.split(vim.fn.getreg(""), "\n"),
      -- The clipboard provider only accepts a single-character regtype, but
      -- getregtype() may return e.g. "\02230" (blockwise + width). Truncate
      -- or getreg('+') fails with "clipboard: provider returned invalid data".
      vim.fn.getregtype(""):sub(1, 1),
    }
  end
  local osc52 = require("vim.ui.clipboard.osc52")
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end

--
-- File handling (backupdir and shada are set in security.lua)
--
vim.opt.backup = true
vim.opt.undofile = true
vim.opt.undolevels = 10240
vim.opt.fileencodings = "utf-8,default,latin1"

--
-- Indentation and formatting
--
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftround = true
vim.opt.smartindent = true
vim.opt.copyindent = true
vim.opt.preserveindent = true
vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.joinspaces = false
vim.opt.formatoptions = "jcroqlnt"
vim.opt.cinoptions = ":0,g0,p2s,t0,+1s,(0"

--
-- Searching
--
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.path:append("**")
vim.opt.wildignore:append("*/tags,*/tmp/*,/var/*,*.a,*.o,*.obj,*.so,*.swp,*.zip,*.tar,*.pyc")
vim.opt.wildmode = "list:longest,full"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"

--
-- Completion (LSP autotrigger is enabled per buffer in lsp.lua)
--
vim.opt.completeopt = "menu,menuone,noinsert,noselect,fuzzy,popup"
vim.opt.pumheight = 10

--
-- Folding (treesitter foldexpr is set per buffer in treesitter.lua)
--
vim.opt.foldlevel = 99
vim.opt.foldtext = ""

--
-- Appearance
--
vim.opt.cmdheight = 0
vim.opt.laststatus = 0 -- set to 3 to show the statusline from statusline.lua
vim.opt.list = false
vim.opt.listchars = { eol = "↵", tab = "→ ", trail = "·" }
vim.opt.colorcolumn = "80"
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.belloff = ""

-- Dark mode follows ~/.darkmode (toggled by ~/bin/darkmode). No external
-- command is run at startup.
vim.o.background = vim.uv.fs_stat(vim.fn.expand("~/.darkmode")) and "dark" or "light"
-- Builtin since nvim 0.12 (Latte for light, Mocha for dark): no plugin needed.
vim.cmd.colorscheme("catppuccin")
