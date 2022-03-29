local packer = require('packer')
packer.startup(function(use)
	-- Initialise packer.nvim, package management for Neovim
	-- https://github.com/wbthomason/packer.nvim
	use('wbthomason/packer.nvim')

	---
	--- Indentation and formatting
	---
	use('tpope/vim-sleuth')              -- detects indentation
	use('editorconfig/editorconfig-vim') -- read .editorconfig

	-- Align code in visual mode (e.g. vipga) and motion/text object (e.g. gaip)
	use({
		'junegunn/vim-easy-align',
		config = function()
			vim.api.nvim_set_keymap('n', 'ga', '<Plug>(EasyAlign)', { silent = true })
			vim.api.nvim_set_keymap('x', 'ga', '<Plug>(EasyAlign)', { silent = true })
		end
	})

	-- Language server integration collection
	use({
		'neovim/nvim-lspconfig',
		config = function()
			require('plugins/lsp-config')
		end,
	})

	-- Incremental parsing for programming tools
	use({
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = function()
			require('plugins/treesitter')
		end,
	})

	-- Completion engine
	use({
		'hrsh7th/nvim-cmp',
		requires = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
		},
		config = function()
			require('plugins/nvim-cmp')
		end,
	})

	-- Snippets
	use({
		'L3MON4D3/LuaSnip',
		config = function()
			require('luasnip/loaders/from_vscode').lazy_load()
		end,
	})

	--
	-- File handling
	--
	use('dietsche/vim-lastplace') -- restore cursor position

	-- Commenting
	use({
		'b3nj5m1n/kommentary',
		config = function()
			require('kommentary.config').use_extended_mappings()

			vim.api.nvim_set_keymap('n', '//', '<Plug>kommentary_line_default', { silent = true })
			vim.api.nvim_set_keymap('v', '//', '<Plug>kommentary_visual_default', { silent = true })

			require('kommentary.config').configure_language('default', {
				prefer_single_line_comments = true,
			})
		end,
	})

	--
	-- Version control system related
	--
	use({
		'lewis6991/gitsigns.nvim',
		requires = { 'nvim-lua/plenary.nvim' },
		config = function()
			require('gitsigns').setup()
		end,
	})

	---
	--- Color scheme
	---
	use({
		'rose-pine/neovim',
		as = 'rose-pine',
		tag = 'v1.*',
		config = function()
			require('rose-pine').setup({ dark_variant = 'main' })
			vim.cmd('colorscheme rose-pine')
		end
	})

	---
	--- Statusbar
	---
	use({
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true },
		config = function()
			require('lualine').setup({
				options = {
					theme = 'rose-pine-alt'
				}
			})
		end
	})
end)

vim.cmd([[
	augroup packer_user_config
		autocmd!
		autocmd BufWritePost plugins.lua source <afile> | PackerCompile
	augroup end
]])
