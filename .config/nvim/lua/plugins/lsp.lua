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
            -- Limit worker threads: default is num_cpus, which on a big machine
            -- means many parallel rustc processes and gigabytes of RSS per
            -- rust-analyzer instance.
            numThreads = 4,

            cargo = {
              -- run only for used target
              -- allTargets = false,

              -- keep separate target directory to not block cargo
              -- https://github.com/rust-lang/rust-analyzer/issues/4616
              -- https://github.com/rust-lang/rust-analyzer/issues/6007
              targetDir = true,

              extraEnv = {
                ["MOLD_JOBS"] = "1",
              },
            },
            check = {
              -- Cap the number of parallel rustc invocations during background
              -- checks — the main source of the many rustc processes at the top
              -- of `top`. 2 is enough to keep feedback fast without flooding RAM.
              numThreads = 2,
              extraEnv = {
                ["MOLD_JOBS"] = "1",
              },
            },
            -- Reduce the syntax-tree LRU cache. Default is unbounded; 64 trades
            -- a bit of re-parse speed for significantly lower RSS per instance.
            lru = {
              capacity = 64,
            },
            lens = {
              enable = false,
            },
            -- https://rust-analyzer.github.io/book/editor_features.html#setting-runnable-environment-variables
            runnables = {
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
