return {
  -- language server configurations
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      -- add key CTRL-] -- jump to tag, in addition to gd
      keys[#keys + 1] = { "<C-]>", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition", has = "definition" }
      -- add <leader>e -- temporary until <leader>cd is noted
      keys[#keys + 1] = { "<leader>e", vim.diagnostic.open_float, desc = "Line Diagnostics" }

      -- make sure hover window doesn't span more than 80 wide
      local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts)
        opts = opts or {}
        opts.max_width = opts.max_width or 80
        return orig_util_open_floating_preview(contents, syntax, opts)
      end
    end,

    opts = {
      servers = {
        bashls = {},
        ccls = {
          init_options = {
            compilationDatabaseDirectory = "build",
            index = { threads = 2 },
          },
        },
        dockerls = {},
        gopls = {
          analyses = { unusedparams = true },
          staticcheck = false,
        },
        graphql = {},
        jsonnet_ls = {},
        lua_ls = {},
        pyright = {},
        rust_analyzer = {},
        terraformls = {},
        tflint = {},
        yamlls = {},
      },
    },
  },

  -- handle installation of linters, formatters etc
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- "checkmake",
        "markdownlint",
        "shellcheck",
        "shfmt",
        "stylua",
        "tflint",
        "tfsec",
      },
    },
  },

  -- additional things not handled by the language servers
  {
    "jose-elias-alvarez/null-ls.nvim",
    -- event = { "BufReadPre", "BufNewFile" },
    -- dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        debug = false,
        sources = {
          nls.builtins.code_actions.shellcheck,

          nls.builtins.completion.spell,

          nls.builtins.formatting.goimports,
          -- nls.builtins.formatting.protolint,
          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.terraform_fmt,

          nls.builtins.diagnostics.checkmake,
          nls.builtins.diagnostics.golangci_lint,
          nls.builtins.diagnostics.markdownlint,
          nls.builtins.diagnostics.shellcheck,
          nls.builtins.diagnostics.sqlfluff.with({ timeout = 60000 }),
          nls.builtins.diagnostics.tfsec,
          nls.builtins.diagnostics.terraform_validate,
        },
      }
    end,
  },
}
