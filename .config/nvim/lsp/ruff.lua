-- ruff: prefers the project's own pinned ruff (<root>/.venv/bin/ruff, e.g.
-- from `uv sync`) so formatting matches CI; falls back to the nix base
-- version. Only ever runs in trusted roots.
local trust = require("config.trust")

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local bin = "ruff"
    local root = config.root_dir
    for _, dir in ipairs({ root, root and vim.fs.root(root, { ".git" }) }) do
      local candidate = dir and dir .. "/.venv/bin/ruff"
      if candidate and vim.fn.executable(candidate) == 1 then
        bin = candidate
        break
      end
    end
    return vim.lsp.rpc.start({ bin, "server" }, dispatchers, { cwd = root })
  end,
  filetypes = { "python" },
  root_dir = trust.root_dir({ "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" }),
  settings = {},
}
