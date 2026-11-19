-- Native LSP. Server configs live in ../../lsp/<name>.lua. Every config uses
-- trust.root_dir(), so servers only start inside trusted roots (trust.lua).
--
-- Binaries come from nix (home.nix) except rust-analyzer, which comes from
-- rustup so it matches the project's rust-toolchain.toml.

vim.lsp.enable({
  "gopls",
  "pyright",
  "ruff",
  "rust_analyzer",
  "lua_ls",
  "taplo",
})

vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
  float = { border = "rounded", source = "if_many" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN] = "W",
      [vim.diagnostic.severity.HINT] = "H",
      [vim.diagnostic.severity.INFO] = "I",
    },
  },
})

--
-- Format on save (toggle with <leader>uf, like LazyVim's vim.g.autoformat)
--
vim.g.autoformat = true

-- Formatter per filetype; other servers attached to the buffer are ignored.
local formatters = {
  go = "gopls",
  python = "ruff",
  rust = "rust_analyzer",
  toml = "taplo",
}

local function organize_imports(client, buf)
  local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
  params.context = { only = { "source.organizeImports" }, diagnostics = {} }
  local res = client:request_sync("textDocument/codeAction", params, 1000, buf)
  for _, action in ipairs(res and res.result or {}) do
    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
    end
  end
end

local function format(buf)
  local name = formatters[vim.bo[buf].filetype]
  if not name then
    return
  end
  local client = vim.lsp.get_clients({ bufnr = buf, name = name })[1]
  if not client then
    return
  end
  if name == "gopls" then
    organize_imports(client, buf) -- replaces goimports
  end
  vim.lsp.buf.format({ bufnr = buf, id = client.id, timeout_ms = 3000 })
end

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("user_lsp_format", { clear = true }),
  callback = function(ev)
    if vim.g.autoformat and vim.b[ev.buf].autoformat ~= false then
      format(ev.buf)
    end
  end,
})

vim.api.nvim_create_user_command("Format", function()
  format(0)
end, { desc = "Format buffer with its LSP formatter" })

--
-- Per-buffer setup
--
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    local buf = ev.buf

    if client.name == "ruff" then
      client.server_capabilities.hoverProvider = false -- pyright does hover
    end

    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
    end

    -- nvim already maps: K, grn (rename), gra (code action), grr (references),
    -- gri (implementation), grt (type definition), gO (symbols), ]d/[d,
    -- <C-s> (signature help, insert). Extra mappings:
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
    end
    local fzf = require("fzf-lua")
    map("n", "gd", fzf.lsp_definitions, "Goto Definition")
    map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
    map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
    map("n", "<leader>cl", "<cmd>checkhealth vim.lsp<cr>", "Lsp Info")
    map("n", "<leader>ch", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
    end, "Toggle Inlay Hints")
  end,
})
