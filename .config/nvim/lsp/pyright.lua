-- pyright from nix. Uses the project's .venv interpreter when present
-- (replaces venv-selector.nvim).
local trust = require("config.trust")

---@type vim.lsp.Config
return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_dir = trust.root_dir({
    "pyrightconfig.json",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    ".git",
  }),
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
  before_init = function(_, config)
    local root = config.root_dir
    for _, dir in ipairs({ root, vim.fs.root(root, { ".git" }) }) do
      local python = dir and dir .. "/.venv/bin/python"
      if python and vim.uv.fs_stat(python) then
        config.settings.python.pythonPath = python
        return
      end
    end
  end,
}
