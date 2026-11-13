local trust = require("config.trust")

---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_dir = trust.root_dir({ ".luarc.json", ".luarc.jsonc", "stylua.toml", ".stylua.toml", ".git" }),
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      completion = { callSnippet = "Replace" },
      hint = { enable = true },
      telemetry = { enable = false },
    },
  },
  on_init = function(client)
    -- Inside the nvim config: teach lua_ls about the nvim runtime.
    local root = client.workspace_folders and client.workspace_folders[1].name
    if root and vim.startswith(root, vim.fn.stdpath("config")) then
      client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
        runtime = { version = "LuaJIT", path = { "lua/?.lua", "lua/?/init.lua" } },
        workspace = { library = { vim.env.VIMRUNTIME } },
      })
    end
  end,
}
