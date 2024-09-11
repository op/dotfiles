return {
  -- language server configurations
  {
    "neovim/nvim-lspconfig",

    opts = {
      inlay_hints = { enabled = false },

      setup = {
        rust_analyzer = function()
          return true
        end,
      },

      servers = {
        bashls = {},
        bufls = {},
        clangd = {
          filetypes = { "c", "cpp", "cuda", "hpp" },
        },
        -- use clangd instead
        -- https://github.com/MaskRay/ccls/issues/951
        -- ccls = {
        --   init_options = {
        --     compilationDatabaseDirectory = "build",
        --     index = { threads = 2 },
        --   },
        -- },
        dockerls = {},
        gopls = {
          cmd = {
            "gopls",
            -- "-rpc.trace",
            -- "-remote=auto",
            -- "-debug=localhost:6060",
          },
          -- settings = {
          --   gopls = {
          --     analyses = {
          --       fieldalignment = true,
          --       unusedparams = true,
          --     },
          --     staticcheck = false,
          --   },
          -- },
          graphql = {},
          jsonls = {},
          jsonnet_ls = {},
          lua_ls = {},
          -- pyright = {
          --   enabled = false,
          --   mason = false,
          -- },
          -- ruff = {},
          -- rust_analyzer = {},
          terraformls = {},
          tflint = {},
          tsserver = {},
          yamlls = {
            settings = {
              yaml = {
                keyOrdering = false,
              },
            },
          },
        },
      },
    },
  },

  -- handle installation of linters, formatters etc
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.eensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.eensure_installed, {
        "basedpyright",
        "buf-language-server",
        "goimports",
        "gofumpt",
        "markdownlint",
        "rust-analyzer",
        "ruff",
        "shfmt",
        "sqlfluff",
        "stylua",
        "tflint",
        "tfsec",
      })
    end,
  },

  -- additional things not handled by the language servers
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      -- opts.debug = true
      opts.sources = vim.list_extend(opts.sources or {}, {
        null_ls.builtins.completion.spell,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.terraform_fmt,

        null_ls.builtins.diagnostics.checkmake,
        -- null_ls.builtins.diagnostics.golangci_lint.with({
        --   env = {
        --     -- limit memory usage
        --     -- https://golangci-lint.run/usage/performance/
        --     -- https://go.dev/doc/gc-guide
        --     GOGC = "10",
        --     GOMEMLIMIT = "512MiB",
        --   },
        -- }),
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.diagnostics.sqlfluff.with({ timeout = 60000 }),
        null_ls.builtins.diagnostics.tfsec,
        null_ls.builtins.diagnostics.terraform_validate,
      })
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    lazy = false, -- This plugin is already lazy
  },
}
