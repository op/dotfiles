local packer = require("packer")
packer.startup(function(use)
	-- Initialise packer.nvim, package management for Neovim
	-- https://github.com/wbthomason/packer.nvim
	use("wbthomason/packer.nvim")

	---
	--- Indentation and formatting
	---
	use("tpope/vim-sleuth") -- detects indentation
	use("editorconfig/editorconfig-vim") -- read .editorconfig

	-- Align code in visual mode (e.g. vipga) and motion/text object (e.g. gaip)
	use({
		"junegunn/vim-easy-align",
		config = function()
			vim.api.nvim_set_keymap("n", "ga", "<Plug>(EasyAlign)", { silent = true })
			vim.api.nvim_set_keymap("x", "ga", "<Plug>(EasyAlign)", { silent = true })
		end,
	})

	-- Language server integration collection
	use({
		"neovim/nvim-lspconfig",
		config = function()
			require("./plugins/lspconfig")
		end,
	})

	-- Whenever there is no language server
	use({
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			require("./plugins/null-ls")
		end,
	})

	-- Incremental parsing for programming tools
	use({
		"nvim-treesitter/nvim-treesitter",
		commit = "9425591", -- neovim 0.7+ is required after
		requires = {
			"p00f/nvim-ts-rainbow",
		},
		run = ":TSUpdate",
		config = function()
			require("./plugins/treesitter")
		end,
	})

	-- Completion engine
	use({
		"hrsh7th/nvim-cmp",
		commit = "93cf84f", -- neovim 0.7+ is required after
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			require("./plugins/cmp")
		end,
	})

	-- XXX this is to downgrade version
	use({
		"saadparwaiz1/cmp_luasnip",
		commit = "b108297", -- neovim 0.7+
	})

	-- Snippets
	use({
		"L3MON4D3/LuaSnip",
		config = function()
			require("luasnip/loaders/from_vscode").lazy_load()
		end,
	})

	use({
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("trouble").setup({})
		end,
	})


	--
	-- File handling
	--
	use("dietsche/vim-lastplace") -- restore cursor position

	-- Set filetype specific
	use({
		"nathom/filetype.nvim",
		config = function()
			require("filetype").setup({
				overrides = {
					extensions = {
						tf = "terraform",
						tfvars = "terraform",
						tfstate = "json",
					},
				},
			})
		end,
	})

	-- Commenting
	use({
		"b3nj5m1n/kommentary",
		config = function()
			require("kommentary.config").use_extended_mappings()

			vim.api.nvim_set_keymap("n", "//", "<Plug>kommentary_line_default", { silent = true })
			vim.api.nvim_set_keymap("v", "//", "<Plug>kommentary_visual_default", { silent = true })

			require("kommentary.config").configure_language("default", {
				prefer_single_line_comments = true,
			})
		end,
	})

	--
	-- Specific language extensions and tools
	--
	use({
		"ellisonleao/glow.nvim",
		branch = "main",
		config = function()
			vim.g.glow_binary_path = vim.env.HOME .. "/bin"
		end,
	})

	--
	-- Version control system related
	--
	use({
		"lewis6991/gitsigns.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("./plugins/gitsigns")
		end,
	})

	---
	--- Color scheme
	---
	use({
		"rose-pine/neovim",
		as = "rose-pine",
		tag = "v1.*",
		config = function()
			require("rose-pine").setup({ dark_variant = "main" })
			vim.cmd("colorscheme rose-pine")
		end,
	})

	---
	--- Statusbar
	---
	use({
		"nvim-lualine/lualine.nvim",
		config = function()
			require("./plugins/lualine")
		end,
	})
end)

vim.cmd([[
	augroup packer_user_config
		autocmd!
		autocmd BufWritePost plugins.lua source <afile> | PackerCompile
	augroup end
]])
