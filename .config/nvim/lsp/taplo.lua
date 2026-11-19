local trust = require("config.trust")

-- taplo fetches a JSON schema catalog from schemastore.org during
-- `initialize`, before any settings arrive. Point its HTTP client at a dead
-- proxy so nothing leaves the machine, and disable schemas for good measure.
local blackhole = "http://127.0.0.1:9"

---@type vim.lsp.Config
return {
  cmd = { "taplo", "lsp", "stdio" },
  cmd_env = {
    HTTPS_PROXY = blackhole,
    HTTP_PROXY = blackhole,
    https_proxy = blackhole,
    http_proxy = blackhole,
    NO_PROXY = "",
    no_proxy = "",
  },
  filetypes = { "toml" },
  root_dir = trust.root_dir({ ".taplo.toml", "taplo.toml", ".git" }),
  settings = {
    evenBetterToml = { schema = { enabled = false } },
  },
}
