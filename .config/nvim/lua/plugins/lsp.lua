-- Walk up from `start` to find the topmost directory containing a Cargo.toml
-- with a [workspace] table. Pins rust-analyzer to a single workspace root so
-- opening files from sub-crates (or workspace-excluded crates) does not spawn
-- a second rust-analyzer.
local function rust_workspace_root(start)
  local found
  local dir = vim.fs.dirname(start)
  while dir and dir ~= "/" do
    local cargo = dir .. "/Cargo.toml"
    if vim.uv.fs_stat(cargo) then
      local fd = io.open(cargo, "r")
      if fd then
        local content = fd:read("*a")
        fd:close()
        if content:match("%[workspace%]") then
          found = dir
        end
      end
    end
    dir = vim.fs.dirname(dir)
  end
  return found
end

return {
  -- Disable the gopls semanticTokens workaround from the LazyVim go extra.
  -- The stable-release (15.13.0) version indexes
  -- client.config.capabilities.textDocument unguarded, which is nil under
  -- nvim 0.11's vim.lsp.config and errors on every gopls attach. Fixed
  -- upstream (LazyVim#7172) but not yet in a stable release — delete this
  -- override once it ships. Costs gopls semantic-token highlighting until then.
  {
    "neovim/nvim-lspconfig",
    opts = { setup = { gopls = function() end } },
  },
  -- language server configurations
  {
    "mrcjkb/rustaceanvim",
    opts = {
      dap = {
        -- https://github.com/mrcjkb/rustaceanvim/issues/880
        autoload_configurations = false,
      },
      server = {
        root_dir = function(filename, default)
          return rust_workspace_root(filename) or default(filename)
        end,
        -- Run rust-analyzer in its own systemd scope with a hard memory cap
        -- and swap disabled for it. If it blows past the cap the kernel
        -- OOM-kills rust-analyzer alone instead of swapping the whole
        -- machine to death.
        cmd = {
          "systemd-run",
          "--user",
          "--scope",
          "--quiet",
          "-p",
          "MemoryMax=10G",
          "-p",
          "MemorySwapMax=0",
          "rust-analyzer",
        },
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
              -- Cap the parallel rustc invocations during background checks.
              extraArgs = { "--jobs", "2" },
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
