-- gopls from nix. It uses the `go` on PATH; a project's go.mod `toolchain`
-- line still decides the Go version (GOTOOLCHAIN=auto).
local trust = require("config.trust")

---@type vim.lsp.Config
return {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = trust.root_dir({ "go.work", "go.mod", ".git" }),
  settings = {
    gopls = {
      gofumpt = true,
      codelenses = { generate = true, test = true, tidy = true, upgrade_dependency = true },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      analyses = { nilness = true, unusedparams = true, unusedwrite = true, useany = true },
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-node_modules" },
      semanticTokens = true,
    },
  },
}
