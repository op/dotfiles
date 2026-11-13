-- Hardening. Loaded first from init.lua.

--
-- Code execution from file contents / the working directory
--
vim.o.modeline = false -- modelines have a long CVE history; never honor them
vim.o.modelineexpr = false
vim.o.exrc = false -- never source .nvim.lua / .exrc from the cwd
vim.o.secure = true

-- Builtin plugins that fetch remote content or unpack archives.
vim.g.loaded_netrw = 1 -- also handles scp://, http:// etc.
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_2html_plugin = 1
-- Remote plugin hosts: nothing here uses them.
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

--
-- Private state on disk (backups, undo, swap, shada, logs)
--
local state = vim.fn.stdpath("state")
local backupdir = state .. "/backup"
vim.fn.mkdir(backupdir, "p", tonumber("700", 8))
for _, dir in ipairs({ state, backupdir, state .. "/swap", state .. "/undo", state .. "/shada" }) do
  if vim.uv.fs_stat(dir) then
    vim.uv.fs_chmod(dir, tonumber("700", 8))
  end
end
local log = state .. "/log"
if vim.uv.fs_stat(log) then
  vim.uv.fs_chmod(log, tonumber("600", 8))
end
vim.opt.backupdir = { backupdir .. "//" }

-- Remember marks, history and search, but never register contents (that is
-- where yanked secrets would end up).
vim.o.shada = "!,'200,<0,s10,h,:500,/100"

--
-- Sensitive files: keep their contents out of swap/undo/backup/shada and out
-- of the system clipboard.
--
local sensitive_patterns = {
  "*.env",
  ".env",
  ".env.*",
  "*.pem",
  "*.key",
  "*.p12",
  "*.pfx",
  "*.tfvars",
  "*.age",
  "*.gpg",
  "*/.ssh/*",
  "*/.gnupg/*",
  "*/.aws/credentials",
  "*/.aws/config",
  "*/.docker/config.json",
  "*/.kube/config",
  "*/.netrc",
  "*/.pgpass",
  "*/.git-credentials",
  "/dev/shm/*", -- pass, gopass
  "/tmp/*", -- sops, crontab -e, vipe, ...
  "/var/tmp/*",
}

local group = vim.api.nvim_create_augroup("user_sensitive", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = group,
  pattern = sensitive_patterns,
  callback = function(ev)
    vim.b[ev.buf].sensitive = true
    vim.bo[ev.buf].swapfile = false
    vim.bo[ev.buf].undofile = false
    -- Global options: once a sensitive file was opened, this session writes
    -- no shada and no backups at all.
    vim.o.shada = ""
    vim.o.backup = false
    vim.o.writebackup = false
  end,
})

-- 'clipboard' is global, so swap it out while a sensitive buffer is current.
local saved_clipboard
vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  callback = function(ev)
    if vim.b[ev.buf].sensitive then
      if saved_clipboard == nil then
        saved_clipboard = vim.o.clipboard
      end
      vim.o.clipboard = ""
    elseif saved_clipboard ~= nil then
      vim.o.clipboard = saved_clipboard
      saved_clipboard = nil
    end
  end,
})

--
-- Big files (replaces faster.nvim): no treesitter, LSP, syntax, undo or swap.
--
local big_file_size = 1.5 * 1024 * 1024

vim.api.nvim_create_autocmd("BufReadPre", {
  group = group,
  callback = function(ev)
    local stat = vim.uv.fs_stat(ev.match)
    if stat and stat.size > big_file_size then
      vim.b[ev.buf].bigfile = true
      vim.bo[ev.buf].swapfile = false
      vim.bo[ev.buf].undofile = false
      vim.bo[ev.buf].syntax = "off"
    end
  end,
})
