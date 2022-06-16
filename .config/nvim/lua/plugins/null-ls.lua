local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		-- null_ls.builtins.formatting.gofmt,
		-- null_ls.builtins.formatting.goimports,
		-- null_ls.builtins.formatting.terraform_fmt,
		null_ls.builtins.formatting.protolint,
		null_ls.builtins.formatting.stylua,
		-- null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.diagnostics.markdownlint,
		null_ls.builtins.completion.spell,
	},
	debug = true,
})

vim.cmd("autocmd BufWritePre *.lua lua vim.lsp.buf.formatting_sync()")
