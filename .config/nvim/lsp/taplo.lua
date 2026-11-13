local trust = require("config.trust")

---@type vim.lsp.Config
return {
  cmd = { "taplo", "lsp", "stdio" },
  filetypes = { "toml" },
  root_dir = trust.root_dir({ ".taplo.toml", "taplo.toml", ".git" }),
}
