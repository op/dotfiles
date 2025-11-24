return {
  -- language server configurations
  {
    "mrcjkb/rustaceanvim",
    opts = {
      dap = {
        -- https://github.com/mrcjkb/rustaceanvim/issues/880
        autoload_configurations = false,
      },
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
            check = {
              -- TODO: does this actually work?
              extraEnv = {
                ["MOLD_JOBS"] = "1",
              },
            },
            lens = {
              enable = false, -- disable all lenses
            },
            -- https://rust-analyzer.github.io/book/editor_features.html#setting-runnable-environment-variables
            runnables = {
              -- TODO: does this actually work?
              extraEnv = {
                ["MOLD_JOBS"] = "1",
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
