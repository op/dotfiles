local lspconfig = require("lspconfig")

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

local signs = { Error = "🔥", Warn = "⚠️ ", Hint = "💡", Info = "💡" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap=true, silent=true, buffer=bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "<C-]>", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<leader>f", function()
		vim.lsp.buf.formatting()
	end, bufopts)
end

local config = { on_attach = on_attach }

lspconfig.bashls.setup({ on_attach = on_attach })
lspconfig.ccls.setup({
	on_attach = on_attach,
	init_options = {
		compilationDatabaseDirectory = "build",
		index = {
			threads = 2,
		},
		-- clang = {
		-- excludeArgs = { "-frounding-math"}
		-- },
	},
})
lspconfig.dockerls.setup({ on_attach = on_attach })
lspconfig.eslint.setup({ on_attach = on_attach })
lspconfig.golangci_lint_ls.setup({ on_attach = on_attach })
lspconfig.gopls.setup({
	on_attach = on_attach,
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = false,
		},
	},
})
lspconfig.graphql.setup({ on_attach = on_attach })
lspconfig.jsonnet_ls.setup({ on_attach = on_attach })
-- lspconfig.marksman.setup({ on_attach = on_attach })
lspconfig.pyright.setup({ on_attach = on_attach })
lspconfig.rust_analyzer.setup({ on_attach = on_attach })
lspconfig.sumneko_lua.setup({ on_attach = on_attach })
lspconfig.terraformls.setup({ on_attach = on_attach })
lspconfig.tflint.setup({ on_attach = on_attach })
lspconfig.tsserver.setup({ on_attach = on_attach })
lspconfig.yamlls.setup({ on_attach = on_attach })

-- vim.lsp.set_log_level("debug")

-- vim.cmd("autocmd BufWritePre *.ts,*.tsx,*.js,*.jsx,*.vue,*.svelte EslintFixAll")
-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
-- 	pattern = { "*.go", "*.rs", "*.tf" },
-- 	callback = function() 
-- 		vim.lsp.buf.format()
-- 	end
-- })

vim.api.nvim_create_autocmd(
	{ "BufRead", "BufNewFile" },
	{ pattern = { "Dockerfile.*", "*.Dockerfile" }, command = "setlocal filetype=dockerfile" }
)

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').goimport()
  end,
})
