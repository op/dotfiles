-- rust-analyzer via the rustup proxy (~/.cargo/bin), so the version follows
-- the project's rust-toolchain.toml. Replaces rustaceanvim; notably no
-- .vscode/settings.json is ever read from the project.
--
-- Note: proc macros run project code. That is acceptable here only because
-- servers are limited to trusted roots (lua/config/trust.lua).
local trust = require("config.trust")

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

---@type vim.lsp.Config
return {
  -- Run rust-analyzer in its own systemd scope with a hard memory cap
  -- and swap disabled for it. If it blows past the cap the kernel
  -- OOM-kills rust-analyzer alone instead of swapping the whole
  -- machine to death. Started from the project root so rustup resolves the
  -- project's rust-toolchain.toml (`rustup component add rust-analyzer
  -- --toolchain <channel>` once per toolchain).
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start({
      "systemd-run",
      "--user",
      "--scope",
      "--quiet",
      "-p",
      "MemoryMax=10G",
      "-p",
      "MemorySwapMax=0",
      vim.fn.expand("~/.cargo/bin/rust-analyzer"),
    }, dispatchers, { cwd = config.root_dir })
  end,
  filetypes = { "rust" },
  root_dir = trust.root_dir({ "Cargo.toml", "rust-project.json", ".git" }, rust_workspace_root),
  capabilities = {
    experimental = { serverStatusNotification = true },
  },
  -- rust-analyzer configuration
  -- https://rust-analyzer.github.io/book/configuration.html
  settings = {
    ["rust-analyzer"] = {
      -- Limit worker threads: default is num_cpus, which on a big machine
      -- means many parallel rustc processes and gigabytes of RSS per
      -- rust-analyzer instance.
      numThreads = 4,

      cargo = {
        -- Keep separate target directory to not block cargo
        -- https://github.com/rust-lang/rust-analyzer/issues/4616
        -- https://github.com/rust-lang/rust-analyzer/issues/6007
        targetDir = true,

        -- Use default to not build all examples etc. Mostly to keep memory
        -- down. This has some big drawbacks.
        features = "default",

        -- Skipping tests, benches and examples targets cuts memory
        -- significantly.
        allTargets = false,

        -- Disable extra build scripts that seem to trigger OOM due to cc1 duckdb
        buildScripts = { enable = false },

        extraEnv = {
          ["MOLD_JOBS"] = "1",
          ["CARGO_BUILD_JOBS"] = "1", -- parallel rustc jobs
          ["NUM_JOBS"] = "1", -- parallel cc1 jobs within each build script
        },
      },
      check = {
        -- Cap the parallel rustc invocations during background checks.
        extraArgs = { "--jobs", "1" },
        extraEnv = {
          ["MOLD_JOBS"] = "1",
          ["CARGO_BUILD_JOBS"] = "1", -- parallel rustc jobs
        },
        -- Disable check of full workspace on package change.
        workspace = false,
      },
      -- Reduce the syntax-tree LRU cache. Default is unbounded; 64 trades
      -- a bit of re-parse speed for significantly lower RSS per instance.
      lru = { capacity = 64 },
      -- Skip the eager full-workspace warm-up on startup; biggest single
      -- contributor to peak RSS during initial indexing on big repos.
      cachePriming = { enable = false },
      lens = { enable = false },
      -- Prevents cargo test discovery runs, which link full binaries and
      -- spike memory.
      testExplorer = false,
      procMacro = {
        enable = true,
        -- Increase performance by running many proc-macro-srv instances.
        processes = 8,
      },
      -- https://rust-analyzer.github.io/book/editor_features.html#setting-runnable-environment-variables
      runnables = {
        extraEnv = { ["MOLD_JOBS"] = "1" },
      },
      rustfmt = { extraArgs = { "+nightly" } },
    },
  },
}
