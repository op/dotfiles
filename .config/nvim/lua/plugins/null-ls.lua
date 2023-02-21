local null_ls = require("null-ls")

local sources = {
}

null_ls.setup({
	debug = true,
	sources = {
		null_ls.builtins.completion.spell,

		-- null_ls.builtins.formatting.gofmt,
		-- null_ls.builtins.formatting.goimports,
		-- null_ls.builtins.formatting.terraform_fmt,
		null_ls.builtins.formatting.protolint,
		-- null_ls.builtins.formatting.stylua,

		null_ls.builtins.diagnostics.checkmake,
		null_ls.builtins.diagnostics.golangci_lint,
		null_ls.builtins.diagnostics.sqlfluff.with({
			timeout = 60000,
		}),
		-- null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.diagnostics.markdownlint,
	},
	-- debug = true,
})

-- vim.cmd("autocmd BufWritePre *.lua lua vim.lsp.buf.formatting_sync()")
-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
-- 	pattern = { "*.lua" },
-- 	callback = function()
-- 		vim.lsp.buf.formatting_sync()
-- 	end,
-- })
