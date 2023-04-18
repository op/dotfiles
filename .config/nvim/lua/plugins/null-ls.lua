local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	debug = false,
	sources = {
		-- null_ls.builtins.code_actions.shellcheck,

		null_ls.builtins.completion.spell,

		-- null_ls.builtins.formatting.gofmt,
		-- null_ls.builtins.formatting.goimports,
		-- null_ls.builtins.formatting.protolint,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.terraform_fmt,

		null_ls.builtins.diagnostics.checkmake,
		null_ls.builtins.diagnostics.golangci_lint,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.diagnostics.sqlfluff.with({
			timeout = 60000,
		}),
		null_ls.builtins.diagnostics.tfsec,
		null_ls.builtins.diagnostics.terraform_validate,

		-- null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.diagnostics.markdownlint,
	},

	-- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						bufnr = bufnr,
						filter = function(client)
							return client.name == "null-ls"
						end,
					})
				end,
			})
		end
	end,
})
