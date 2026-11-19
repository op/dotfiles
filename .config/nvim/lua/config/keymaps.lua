-- Keymaps. Mostly the LazyVim defaults that were in muscle memory.
-- (CTRL-W {h,j,k,l} for windows: no <C-hjkl> overrides on purpose.)
-- LSP maps: lua/config/lsp.lua; git hunks + Claude: lua/config/plugins.lua.
local map = vim.keymap.set
local fzf = require("fzf-lua")

-- Project root: git root first (like the old vim.g.root_spec), then cwd.
local function root()
  return vim.fs.root(0, { ".git", "lua" }) or vim.fn.getcwd()
end

-- Better up/down on wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Buffers
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer" })

-- Misc
map({ "i", "n", "s" }, "<esc>", "<cmd>nohlsearch<cr><esc>", { desc = "Escape and Clear hlsearch" })
map("x", "<", "<gv")
map("x", ">", ">gv")
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "<leader>cf", "<cmd>Format<cr>", { desc = "Format" })
map("n", "<leader>U", function()
  vim.cmd.packadd("nvim.undotree")
  vim.cmd.Undotree()
end, { desc = "Undotree" })

-- Toggles
map("n", "<leader>uf", function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify("Autoformat " .. (vim.g.autoformat and "on" or "off"))
end, { desc = "Toggle Autoformat" })
map("n", "<leader>uw", "<cmd>setlocal wrap!<cr>", { desc = "Toggle Wrap" })
map("n", "<leader>ul", "<cmd>setlocal number!<cr>", { desc = "Toggle Line Numbers" })
map("n", "<leader>ud", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle Diagnostics" })

-- Picker (fzf-lua)
map("n", "<leader><space>", function()
  fzf.files({ cwd = root() })
end, { desc = "Find Files (Root Dir)" })
map("n", "<leader>ff", function()
  fzf.files({ cwd = root() })
end, { desc = "Find Files (Root Dir)" })
map("n", "<leader>fF", fzf.files, { desc = "Find Files (cwd)" })
map("n", "<leader>fg", fzf.git_files, { desc = "Find Files (git-files)" })
map("n", "<leader>fr", fzf.oldfiles, { desc = "Recent" })
map("n", "<leader>fc", function()
  fzf.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find Config File" })
map("n", "<leader>,", fzf.buffers, { desc = "Switch Buffer" })
map("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
map("n", "<leader>/", function()
  fzf.live_grep({ cwd = root() })
end, { desc = "Grep (Root Dir)" })
map("n", "<leader>sg", function()
  fzf.live_grep({ cwd = root() })
end, { desc = "Grep (Root Dir)" })
map("n", "<leader>sG", fzf.live_grep, { desc = "Grep (cwd)" })
map({ "n", "x" }, "<leader>sw", function()
  fzf.grep_cword({ cwd = root() })
end, { desc = "Word (Root Dir)" })
map("n", "<leader>sb", fzf.blines, { desc = "Buffer Lines" })
map("n", "<leader>sd", fzf.diagnostics_document, { desc = "Document Diagnostics" })
map("n", "<leader>sD", fzf.diagnostics_workspace, { desc = "Workspace Diagnostics" })
map("n", "<leader>ss", fzf.lsp_document_symbols, { desc = "Goto Symbol" })
map("n", "<leader>sS", fzf.lsp_live_workspace_symbols, { desc = "Goto Symbol (Workspace)" })
map("n", "<leader>sh", fzf.helptags, { desc = "Help Pages" })
map("n", "<leader>sk", fzf.keymaps, { desc = "Key Maps" })
map("n", "<leader>sR", fzf.resume, { desc = "Resume" })
map("n", "<leader>gs", fzf.git_status, { desc = "Git Status" })
map("n", "<leader>gl", fzf.git_commits, { desc = "Git Log" })

-- lazygit in a terminal tab, closed when lazygit exits
map("n", "<leader>gg", function()
  local cwd = root()
  vim.cmd.tabnew()
  local buf = vim.api.nvim_get_current_buf()
  vim.fn.jobstart({ "lazygit" }, {
    term = true,
    cwd = cwd,
    on_exit = function()
      vim.schedule(function()
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
      end)
    end,
  })
  vim.cmd.startinsert()
end, { desc = "Lazygit (Root Dir)" })

-- Markdown preview in a terminal tab (replaces glow.nvim, which could
-- download the glow binary itself; glow now comes from nix).
vim.api.nvim_create_user_command("Glow", function(opts)
  local file = opts.args ~= "" and opts.args or vim.api.nvim_buf_get_name(0)
  vim.cmd.tabnew()
  vim.fn.jobstart({ "glow", "-p", file }, { term = true })
  vim.cmd.startinsert()
end, { nargs = "?", complete = "file", desc = "Preview markdown with glow" })
