-- Trusted roots: language servers only start for files below these
-- directories. Opening a repo with an LSP runs that repo's code (rust proc
-- macros and build scripts, python interpreters in .venv, go toolchain
-- downloads, ...), so anything else gets plain editing only.
--
-- `:Trust` trusts the current buffer's project root for this session and
-- starts its language servers. `:checkhealth vim.lsp` shows what attached.
local M = {}

M.roots = {
  "~/modal",
  "~/src",
  "~/.config",
}

local session = {}

local function normalize(path)
  return vim.fs.normalize(vim.fn.resolve(vim.fn.fnamemodify(path, ":p")))
end

---@param path string
---@return boolean
function M.is_trusted(path)
  if path == "" then
    return false
  end
  path = normalize(path)
  for _, root in ipairs(vim.list_extend(vim.deepcopy(M.roots), session)) do
    root = normalize(root)
    if path == root or vim.startswith(path, root:gsub("/$", "") .. "/") then
      return true
    end
  end
  return false
end

local warned = {}

--- Build a `root_dir` for vim.lsp.config that only attaches in trusted roots.
---@param markers (string|string[])[]
---@param find_root? fun(fname: string): string?
function M.root_dir(markers, find_root)
  return function(bufnr, on_dir)
    if vim.b[bufnr].bigfile or vim.bo[bufnr].buftype ~= "" then
      return
    end
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = (find_root and find_root(fname)) or vim.fs.root(bufnr, markers)
    if not root then
      return
    end
    if M.is_trusted(root) then
      on_dir(root)
    elseif not warned[root] then
      warned[root] = true
      vim.notify(("LSP disabled: %s is not a trusted root (:Trust to enable)"):format(root), vim.log.levels.WARN)
    end
  end
end

vim.api.nvim_create_user_command("Trust", function(opts)
  local dir = opts.args ~= "" and opts.args or vim.fs.root(0, { ".git" }) or vim.fn.getcwd()
  dir = normalize(dir)
  table.insert(session, dir)
  vim.notify("Trusted for this session: " .. dir)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and M.is_trusted(vim.api.nvim_buf_get_name(buf)) then
      vim.api.nvim_exec_autocmds("FileType", { buffer = buf })
    end
  end
end, { nargs = "?", complete = "dir", desc = "Trust a directory for LSP (this session only)" })

return M
