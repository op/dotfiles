""""""""""""""""""""""""""""""
"""          __
"""  .--.--.|__|.--------.
"""  |  |  ||  ||        |
"""   \___/ |__||__|__|__|
"""
""""""""""""""""""""""""""""""
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48:2;%lu;%lu;%lum"
if &term == "alacritty"
        let &term = "xterm-256color"
endif

" Initialize vim-plug, a Vim plugin manager
" https://github.com/junegunn/vim-plug
silent! if plug#begin('~/.vim/plugged')

""" General
Plug 'tpope/vim-sensible'              " sensible defaults
Plug 'tpope/vim-repeat'                " fix the . command
Plug 'tpope/vim-eunuch'                " commands inside vim, eg :SudoWrite
Plug 'tpope/vim-rsi'                   " readline keybindings in insert and command mode
Plug 'conradirwin/vim-bracketed-paste' " no more :set paste

""" Indentation and formatting
Plug 'editorconfig/editorconfig-vim' " read .editorconfig
Plug 'tpope/vim-surround'            " change surroundings
Plug 'tpope/vim-sleuth'              " detect indentation
Plug 'tweekmonster/wstrip.vim'       " strip modified lines

"" align code with maps for visual mode (e.g. vipga) and motion/text object (e.g. gaip)
Plug 'junegunn/vim-easy-align'
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

"""" Building and code quality
"Plug 'w0rp/ale'                      " code linting and fixing
"Plug 'neomake/neomake'               " linting and make framework
"Plug 'janko-m/vim-test'              " run tests
"nmap <leader>tn :TestNearest<cr>
"nmap <leader>tf :TestFile<cr>
"nmap <leader>ts :TestSuite<cr>
"nmap <leader>tl :TestLast<cr>
"nmap <leader>tv :TestVisit<cr>

"let g:ale_fix_on_save = 1
"let g:ale_fixers = {
"\   'javascript': ['prettier', 'eslint'],
"\   'rust': ['rustfmt'],
"\}
"let g:ale_lint_on_save = 1
"let g:ale_linters = {
"\   'javascript': ['eslint'],
"\}
"let g:ale_set_loclist = 0
"let g:ale_set_quickfix = 1
"" let g:ale_rust_rustfmt_options = '--edition 2018'
Plug 'folke/trouble.nvim'


""" Version control system related
"" Plug 'mhinz/vim-signify'        " shows signs for changed lines
"" Plug 'airblade/vim-gitgutter'   " adds +, - etc in the gutter
"Plug 'gregsexton/gitv'          " similar to gitk, tig
Plug 'tpope/vim-fugitive'       " git wrapper
Plug 'tpope/vim-git'            " git core
Plug 'tpope/vim-rhubarb'        " github integration
"" Plug 'chrisbra/recover.vim'     " show diff when recovering a buffer
"let g:gitgutter_realtime = 0
"let g:gitgutter_eager = 0

""" File handling
"Plug 'januswel/binedit.vim'     " binary files
"Plug 'panozzaj/vim-autocorrect' " autocorrect typsos
"Plug 'sjl/gundo.vim'            " use the mirror of gundo found on github
Plug 'dietsche/vim-lastplace'   " restore cursor position
" Plug 'thaerkh/vim-workspace'    " automated session management
" let g:workspace_autocreate = 1
"Plug 'direnv/direnv.vim'        " enable direnv within vim
"Plug 'tpope/vim-speeddating'    " extend ctrl-a/x with date support and more
Plug 'tpope/vim-commentary'     " easy comment things away
nnoremap // :Commentary<cr>
vnoremap // :Commentary<cr>
" Plug 'b3nj5m1n/kommentary'
" nnoremap // :<Plug>kommentary_line_default<cr>
" vnoremap // :<Plug>kommentary_visual_default<C-c><cr>
"nnoremap <Leader>u :GundoToggle<cr>

"""" File finder
Plug 'kien/ctrlp.vim'           " quickly find files, buffers
let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
"" let g:ctrlp_map = '<c-p>'
"" let g:ctrlp_cmd = 'CtrlP'
"" Plug 'junegunn/fzf'             " go binary et al, requires a
"" Plug 'junegunn/fzf.vim'         " finding files, provides ag, rg et al
"Plug 'lotabout/skim'              " fuzzy finder, requires cargo install skim
Plug 'mhinz/vim-grepper'          " grep in files
" nmap gs  <plug>(GrepperOperator)
" xmap gs  <plug>(GrepperOperator)
nnoremap <leader>gg :Grepper -tool git<cr>
nnoremap <leader>gr :Grepper -tool rg<cr>
nnoremap <leader>gs :Grepper -tool rg -side<cr>
nnoremap <leader>*  :Grepper -tool rg -cword -noprompt<cr>
Plug 'nvim-lua/plenary.nvim'
" Plug 'nvim-telescope/telescope.nvim'
" nnoremap <leader>ff <cmd>Telescope find_files<cr>
" nnoremap <leader>gr <cmd>Telescope live_grep<cr>
" nnoremap <leader>fb <cmd>Telescope buffers<cr>
" nnoremap <leader>fh <cmd>Telescope help_tags<cr>

"let g:grepper = {}
"let g:grepper.tools = ['git', 'rg', 'ag']
"" let g:grepper.open = 0            " disable opening of quickfix window
"let g:grepper.jump = 1              " automatically jump to first match
"let g:grepper.quickfix = 0          " quickfix seem to clash with ALE
"let g:grepper.prompt_mapping_tool = '<leader>g'

"command! Todo Grepper -noprompt -tool git -query -E '(TODO|FIXME|XXX):'

""" Tags and completion
"" Plug 'ludovicchabant/vim-gutentags'
"" let g:gutentags_project_root = ['tags', '.tags']
"" let g:gutentags_ctags_exclude = ['*.go']
"Plug 'valloric/youcompleteme',
" \ { 'do': './install.py --clang-completer --clangd-completer --rust-completer --go-completer --ts-completer' }
"Plug 'chrisbra/unicode.vim'

"augroup myyoucompleteme
"	au!
"	au FileType c,cpp,objc,objcpp,cuda,cs,go,java,javascript,python,rust,typescript nnoremap <C-]>       :YcmCompleter GoTo<cr>
"	au FileType c,cpp,objc,objcpp,cuda,cs,go,java,javascript,python,rust,typescript nnoremap <C-W>]      :split \| :YcmCompleter GoTo<cr>
"	au FileType c,cpp,objc,objcpp,cuda,cs,go,java,javascript,pkthon,rust,typescript nnoremap <C-W><C-]>  :split \| :YcmCompleter GoTo<cr>
"	au FileType c,cpp,objc,objcpp,cuda,cs,go,java,javascript,python,rust,typescript nnoremap <leader>gd  :YcmCompleter GetDoc<cr>
"	au FileType c,cpp,objc,objcpp,cuda,cs,go,java,javascript,python,rust,typescript nnoremap K           :YcmCompleter GetDoc<cr>
"	au FileType java,javascript,typescript nnoremap <leader>oi  :YcmCompleter OrganizeImports<cr>
"augroup END

"""" Syntax files
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-refactor'

Plug 'neovim/nvim-lspconfig' " configurations for lsp clients
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp' " autocompletion

Plug 'onsails/lspkind-nvim' " add symbols to completion

" let g:rustfmt_autosave = 1

"Plug 'sheerun/vim-polyglot'
"" Plug 'cfdrake/vim-carthage'
"" Plug 'chase/vim-ansible-yaml'
"" Plug 'chrisbra/csv.vim'
"" Plug 'cstrahan/vim-capnp'
"" Plug 'derekwyatt/vim-scala'
"" Plug 'fatih/vim-nginx'
"" Plug 'framallo/asciidoc.vim'
"" Plug 'groenewege/vim-less'
"" Plug 'guns/vim-clojure-static'
"" Plug 'hashivim/vim-vagrant'
"" Plug 'jboyens/vim-protobuf'
"" Plug 'jceb/vim-orgmode'
"" Plug 'kchmck/vim-coffee-script'
"" Plug 'keith/swift.vim'
"" Plug 'octol/vim-cpp-enhanced-highlight'
"" Plug 'rodjek/vim-puppet'
"" Plug 'rust-lang/rust.vim'
"" let g:rustfmt_options = '--edition 2018'
"" let g:rustfmt_autosave = 0
"" Plug 'tfnico/vim-gradle'
"" Plug 'udalov/kotlin-vim'
"" Plug 'vim-scripts/groovy.vim'
"" Plug 'pangloss/vim-javascript'
"" Plug 'mxw/vim-jsx'
"" Plug 'jparise/vim-graphql'
"" " Plug 'flowtype/vim-flow'
"" " Plug 'akhaku/vim-java-unused-imports'
"" " Plug 'tpope/vim-classpath'

"" Plug 'fatih/vim-go'
"" let g:go_disable_autoinstall = 1
"" let g:go_echo_command_info = 0
"" let g:go_fmt_fail_silently = 1
"" let g:go_fmt_command = "goimports"
"" let g:go_highlight_functions = 1
"" let g:go_highlight_methods = 1
"" " let g:go_highlight_fields = 1
"" " let g:go_highlight_types = 1
"" let g:go_highlight_operators = 1
"" let g:go_highlight_build_constraints = 1

"" Plug 'tpope/vim-markdown'
"" let g:markdown_fenced_languages = ['go', 'html', 'python', 'bash=sh']
"" " Plug 'plasticboy/vim-markdown'
"Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'yarn install'}
"" let g:instant_markdown_slow = 1
let g:instant_markdown_autostart = 0

"" Plug 'kevinw/pyflakes-vim.git'
"" let g:pyflakes_use_quickfix = 0 " quickfix support in pyflakes is nice, but breaks others

"" Plug 'leafgarland/typescript-vim'
"" Plug 'Quramy/tsuquyomi'
Plug 'jamespeapen/swayconfig.vim'

"""" Snippets
"" Plug 'msanders/snipmate.vim'
"" Plug 'sirver/ultisnips'
Plug 'L3MON4D3/LuaSnip'

"""" Build and test
"Plug 'nvie/vim-flake8' " python pep8
"" Plug 'nvie/vim-pyunit' " python unittest
"let g:PyUnitTestsStructure = 'nose'
"let g:PyUnitTestsRoot = 'test'
"let g:PyUnitTestsSplitWindow = 'bottom'

"""" Syntax sugar
"Plug 'ntpeters/vim-better-whitespace'   " mark trailing whitespace. always
"" Plug 'jeaye/color_coded'                " improve highlight for C, C++
"Plug 'junegunn/rainbow_parentheses.vim' " unique color for parentheses
"Plug 'tpope/vim-unimpaired'             " handy bracket mappings

"""" Statusbar
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
"let g:airline#extensions#ale#enabled = 1

"""" Color scheme
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'w0ng/vim-hybrid'
Plug 'tomasr/molokai'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'arcticicestudio/nord-vim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'rose-pine/neovim', { 'as': 'rose-pine' }

call plug#end()
endif

"" Run neomake on write and on mode change (with delay)
"call neomake#configure#automake('w')

" set completeopt=menu,menuone,noselect
set completeopt=menu,menuone,noselect

lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'
  local lspkind = require'lspkind'
  local luasnip = require'luasnip'

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
  end

  cmp.setup({
    mapping = {
      ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
      ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-u>"] = cmp.mapping.scroll_docs(4),
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping(cmp.mapping.confirm({ select = false }), { 'i', 'c' }),
      ['<C-y>'] = cmp.mapping(cmp.mapping.confirm({ select = false }), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    },

    documentation = {
      border = rounded,
    },

    formatting = {
       format = lspkind.cmp_format {
          with_text = true,
          menu = {
             buffer   = "[buf]",
             luasnip  = "[LuaSnip]",
             nvim_lsp = "[LSP]",
             path     = "[path]",
          },
       },
    },

    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },

    sources = cmp.config.sources({
      {
        name = 'buffer',
        priority = 1,

      },
      {
        name = 'luasnip',
        priority = 4,
      },
      {
        name = 'tmux',
        priority = 2,
        option = {
          all_panes = true,
          trigger_characters = {},
        }
      },
      {
        name = 'nvim_lsp',
        priority = 3,
      },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  -- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
  --   capabilities = capabilities
  -- }
EOF

""
"" General
""
set clipboard=unnamed   " Use clipboard '*' for all
set colorcolumn=80      " Show marginal
set nowrap              " Don't display long lines as wrapped
set nofixendofline      " Stop adding endlines
set showcmd             " Show partial commands before finished
set scrolloff=2         " Show lines above and below cursor
set sidescrolloff=2     " Show columns left and right of cursor
set sidescroll=1        " Scroll whole page horizontally
"set timeoutlen=400      " Set shorter timeout for commands
"set ttimeout
"set ttimeoutlen=50
set wildmode=list:longest,list:full
set wildignore+=*.a,*.o,*.obj,*.pyc,*/tags
set wildignore+=*/.git/*,*.swp

"
" File handling
"
set autowrite " automatically save before :next, :make etc
set autoread " automatically reload buffer w/o local changes
set backup " make backups
set backupdir=~/.cache/nvim/backup
set directory=~/.cache/nvim/temp
set undofile
set undodir=~/.cache/nvim/undo
set undolevels=10240
set fileencodings=utf-8,default,latin1

"" i have vim_bridge etc here
"if has('python')
"	let $PYTHONPATH .= ":/home/orion/lib/python"
"endif

""
"" Searching
""
set hlsearch            " Syntax highlighting
set ignorecase          " Search without cases
set smartcase           " Except for upper-cases I write myself
"" set report=0            " Always show number of changes

""
"" Statusline
""
"let g:airline_theme='hybrid'
"let g:airline_symbols_ascii = 1
"let g:airline#extensions#hunks#enabled = 0
"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = ' '
"let g:airline#extensions#whitespace#enabled = 0
"let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
"" let g:airline_section_y = airline#section#create_right(['ffenc', '%{go#statusline#Show()}'])
"let g:airline_section_z = airline#section#create(['%2v', ':%2l'])

"
" ui
"
"set nofoldenable                       " Disable folds
set listchars=eol:↵,tab:→\             " List chars for end of line and tabs
set listchars+=trail:·                 " + trailing white-space
"set listchars+=extends:⇉,precedes:⇇    " + side scrolling
"set fillchars=vert:\│,fold:·
"" set shortmess-=aI                      " Remove intro and all abbrevations
"" set shortmess+=T                       " Truncate very long messages in the middle
"" set showfulltag                        " Show both tag and search pattern
"" set helpheight=12

""
"" Spelling
""
"setlocal nospell spelllang=en_gb
"nmap <leader>s :setlocal spell! spell?<cr>

""
"" Misc
""
"set diffopt=filler,context:3,vertical
set selectmode=mouse,key
"set mousemodel=popup
"" set mouse=i
"set keymodel=startsel

""
"" Keybindings
""

"" F4: Toggle list (display unprintable characters).
"nnoremap <silent> <F4> :setl list!<Bar>setl list?<cr>

""
"" Colors and Highlights
""

"" Color scheme
if filereadable(expand("~/.darkmode"))
	set background=dark
	" let g:tokyonight_style = "night"
else
	set background=light
	" let g:tokyonight_style = "light"
endif

" colorscheme nord
colorscheme hybrid
" colorscheme tokyonight
colorscheme rose-pine
" colorscheme catppuccin

"
" Indentation and formatting
"
set copyindent
set preserveindent
set shiftwidth=2           " Autoindent step
set tabstop=2              " Show tabs as 2 spaces
set formatoptions+=c       " Auto-wrap comments using textwidth
set formatoptions+=r       " Insert comments on enter in insert
set formatoptions+=o       " Insert comments on o or O fro normal
set formatoptions+=n       " Recognise numbered lists when formatting
set cinoptions=:0,g0,p2s,t0,+1s,(0

lua <<EOF
require'rose-pine'.setup {
  dark_variant = 'main',
  -- dark_variant = 'moon',
}
EOF

lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = "maintained",

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing
  -- ignore_install = { "javascript" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- list of language that will be disabled
    -- disable = { "c", "rust" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

-- Indentation based on treesitter for the = operator. NOTE: This is an experimental feature.
  indent = {
    enable = true
  },

  refactor = {
    highlight_definitions = { enable = true },
    smart_rename = {
      enable = true,
      keymaps = {
        goto_definition = "gnd",
        smart_rename = "grr",
      },
    },
  },
}
EOF

lua <<EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'eslint', 'graphql', 'rust_analyzer', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF

lua << EOF
  require("trouble").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF

"" Set filestypes on specific prefixes/suffixes
"augroup filetype
"	au!
"	au BufNewFile,BufRead Fastfile      setf ruby
"	au BufNewFile,BufRead reportbug.*   setf mail
"	au BufNewFile,BufRead *.asciidoc    setf asciidoc
"	au BufNewFile,BufRead *.boink       setf proto
"	au BufNewFile,BufRead *.epl         setf sql
"	au BufNewFile,BufRead *.kupu        setf xml
"	au BufNewFile,BufRead *.less        setf css
"	au BufNewFile,BufRead *.nfo         setf nfo
"	au BufNewFile,BufRead *.ppyx        setf pyrex
"	au BufNewFile,BufRead *.proto       setf proto
"	au BufNewFile,BufRead *.pxi         setf pyrex
"	au BufNewFile,BufRead *.scala       setf scala
"	au BufNewFile,BufRead *.tac         setf python
"	au BufNewFile,BufRead *.thrift      setf thrift
"	au BufNewFile,BufRead *.x           setf tf
"	au BufNewFile,BufRead *.zone        setf bindzone

"	" Override these filetypes
"	au BufNewFile,BufRead *.as          setl filetype=actionscript
"augroup END

"" augroup coffee
"" 	au!
""   au BufWritePost *.coffee silent make!
"" augroup END

"augroup go
"	au!
"	au FileType go nmap <leader>gb <Plug>(go-build)
"	au FileType go nmap <leader>gd <Plug>(go-doc)
"	au FileType go nmap <leader>gg <Plug>(go-generate)
"	au FileType go nmap <leader>gi <Plug>(go-info)
"	au FileType go nmap <leader>gl <Plug>(go-lint)
"	au FileType go nmap <leader>gr <Plug>(go-rename)
"	au FileType go nmap <leader>gt <Plug>(go-test)
"	au FileType go nmap <C-]>      <Plug>(go-def)
"	au FileType go nmap <C-W>]     <Plug>(go-def-split)
"augroup END

"augroup java
"	au!
"	au FileType java setl et ts=2 sw=2 tw=78 hls
"	au FileType java noremap <Leader>ji :JavaImport<cr>
"	au FileType java noremap <Leader>jc :JavaCorrect<cr>
"	au FileType java noremap <Leader>jr :JavaRename
"augroup END

augroup rust
	au!
	au FileType rust nmap <leader>rt :RustTest<cr>
	au FileType rust nmap <leader>rr :RustRun<cr>
	au BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 1000)
augroup END

augroup javascript
	au!
	au BufWritePre *.js EslintFixAll
augroup END

"augroup mail
"	au!
"	au FileType mail setl tw=72
"augroup END

"augroup nfo
"	au!
"	au FileType nfo edit ++enc=cp437
"	au FileType nfo setl columns=79 ambiwidth=single nonumber
"	au FileType nfo setl guioptions= laststatus=0
"	au FileType nfo hi normal ctermfg=lightblue guifg=lightblue
"augroup END

"augroup tex
"	au!
"	au FileType tex setl spell
"	let g:tex_comment_nospell = 1
"augroup END

"augroup text
"	au!
"	au FileType text setl tw=78
"augroup END

""
"" Various keybindings
""

"" quickfix
"nnoremap ]q :cnext<cr>zz
"nnoremap [q :cprev<cr>zz
"nnoremap ]l :lnext<cr>zz
"nnoremap [l :lprev<cr>zz
"nnoremap <leader>c :cclose<bar>lclose<cr>

"" buffer
"nnoremap ]b :bnext<cr>
"nnoremap [b :bprev<cr>

"" tabs
"nnoremap ]t :tabn<cr>
"nnoremap [t :tabp<cr>
