---
--- General
---
vim.o.clipboard = 'unnamedplus' -- Use clipboard for ALL operations
vim.o.mouse = ''
-- vim.o.mouse = ''               -- Allow mouse to be used in all modes
vim.o.selectmode = 'mouse,key'
vim.cmd('set nowrap')           -- Don't display long lines as wrapped
vim.cmd('set nofixendofline')   -- Stop adding endlines
vim.o.showmode = false          -- Status bar show's the mode already
vim.o.scrolloff = 2             -- Show lines above and below cursor
vim.o.sidescrolloff = 2         -- Show columns left and right of cursor
vim.o.sidescroll = 1            -- Scroll whole page horizontally
vim.o.ttimeout = true
vim.o.ttimeoutlen = 50

---
--- File handling
---
vim.o.hidden = true
vim.o.autowrite = true -- Save before :next, :make etc
vim.o.autoread = true  -- Reload externally changed buffer w/o local changes
vim.o.backup = true
vim.o.backupdir = vim.fn.expand('~/.cache/nvim/backup/')
vim.o.directory = vim.fn.expand('~/.cache/nvim/swap/')
vim.o.undodir = vim.fn.expand('~/.cache/nvim/undo/')
vim.o.undofile = true
vim.o.undolevels = 10240
vim.g.netrw_dirhistmax = 0
vim.o.fileencodings = 'utf-8,default,latin1'

---
--- Indentation and formatting
---
vim.o.copyindent = true
vim.o.preserveindent = true
vim.o.breakindent = true

vim.o.joinspaces = false
vim.o.expandtab = true

vim.o.softtabstop = 2
vim.o.shiftwidth = 2              -- Autoindent step
vim.o.tabstop = 2                 -- Show tabs as 2 spaces
vim.o.linebreak = true            -- Soft wrap lines
vim.o.breakindent = true          -- Visually indent lines that breaks
vim.opt.formatoptions:append('c') -- Auto-wrap comments using textwidth
vim.opt.formatoptions:append('r') -- Insert comments on enter in insert
vim.opt.formatoptions:append('o') -- Insert comments on o or O from normal 
vim.opt.formatoptions:append('n') -- Recognise numbered lists when formatting
vim.o.cinoptions = ':0,g0,p2s,t0,+1s,(0'

---
--- Searching
---
vim.cmd('set path+=**')
vim.cmd('set wildignore+=*/tags,*/tmp/*,/var/*,*.a,*.o,*.obj,*.so,*.swp,*.zip,*.tar,*.pyc')
vim.o.wildmode = 'longest:full,full'
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

if vim.fn.executable('rg') then
	vim.o.grepprg = 'rg --vimgrep --no-heading --smart-case'
end

---
--- Completion
---
vim.o.completeopt = 'menu,menuone,noinsert,noselect'

---
--- Appearance
--

-- Enable darkmode when ~/.darkmode exists
if vim.fn.filereadable(vim.fn.expand('~/.darkmode')) then
	vim.o.background = 'dark'
else
	vim.o.background = 'light'
end

vim.o.listchars = 'eol:↵,tab:→ ,trail:·'
vim.cmd('set colorcolumn=80')
vim.o.termguicolors = true
-- vim.wo.cursorline = true
-- vim.wo.number = true
vim.wo.signcolumn = 'yes'
vim.o.laststatus = 0
