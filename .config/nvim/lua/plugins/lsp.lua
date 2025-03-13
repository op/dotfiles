return {
  -- language server configurations
  { "williamboman/mason-lspconfig.nvim", version = "805c31" },

  {
    "neovim/nvim-lspconfig",

    opts = {
      servers = {
        bashls = {},
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
          pyright = {
            settings = {
              analysis = {
                extraPaths = {
                  "~/client",
                  "./internal_common",
                  "./server",
                  "./web",
                },
              },
            },
          },
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

  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        default_settings = {
          -- rust-analyzer configuration
          -- https://rust-analyzer.github.io/book/configuration.html
          ["rust-analyzer"] = {
            cargo = {
              -- run only for used target
              -- allTargets = false,

              -- keep separate target directory to not block cargo
              -- https://github.com/rust-lang/rust-analyzer/issues/4616
              -- https://github.com/rust-lang/rust-analyzer/issues/6007
              targetDir = true,

              -- TODO: does this actually work?
              extraEnv = {
                ["MOLD_JOBS"] = "1",
              },
            },
            -- reset all the ignored proc-macros via lazyvim
            -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/rust.lua
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = {},
                ["napi-derive"] = {},
                ["async-recursion"] = {},
              },
            },
            rustfmt = {
              extraArgs = { "+nightly" },
            },
          },
        },
      },
    },
  },
}
