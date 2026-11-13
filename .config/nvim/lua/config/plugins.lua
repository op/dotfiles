-- Third-party plugins, managed by the builtin vim.pack.
--
-- * Exact commits are pinned in nvim-pack-lock.json (tracked in dotfiles);
--   a fresh machine installs exactly those revisions.
-- * Installing a new plugin asks for confirmation (vim.pack default).
-- * Update: `:lua vim.pack.update()` shows the pending changes per plugin;
--   review, `:write` to apply, then `dot diff -- ~/.config/nvim/nvim-pack-lock.json`
--   and commit. Revert: `dot checkout -- ~/.config/nvim/nvim-pack-lock.json`
--   followed by `:lua vim.pack.update(nil, { target = "lockfile" })`.
--
-- Keep this list short. Everything here is pure Lua with no build step and
-- downloads nothing at runtime.

local gh = function(repo)
  return "https://github.com/" .. repo
end

vim.pack.add({
  gh("lewis6991/gitsigns.nvim"), -- git hunks/signs (author is a nvim core maintainer)
  gh("ibhagwan/fzf-lua"), -- fuzzy picker; uses fzf, fd, rg from nix
  gh("coder/claudecode.nvim"), -- only started on demand, see below
  gh("folke/which-key.nvim"), -- popup of pending keymaps
})

--
-- which-key: shows the mappings that can follow a prefix (from their `desc`).
--
local wk = require("which-key")
wk.setup({
  preset = "helix",
  delay = 300, -- ms before the popup; it waits for the next key without a timeout
  icons = { mappings = false }, -- no icon plugin
})
wk.add({
  { "<leader>a", group = "ai (Claude)" },
  { "<leader>b", group = "buffer" },
  { "<leader>c", group = "code" },
  { "<leader>f", group = "file/find" },
  { "<leader>g", group = "git" },
  { "<leader>gh", group = "hunks" },
  { "<leader>q", group = "quit" },
  { "<leader>s", group = "search" },
  { "<leader>u", group = "ui toggles" },
  { "[", group = "prev" },
  { "]", group = "next" },
  { "g", group = "goto" },
})
vim.keymap.set("n", "<leader>?", function()
  wk.show({ global = false })
end, { desc = "Buffer Keymaps (which-key)" })

--
-- gitsigns
--
require("gitsigns").setup({
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "" },
    topdelete = { text = "" },
    changedelete = { text = "▎" },
    untracked = { text = "▎" },
  },
  on_attach = function(buf)
    local gs = require("gitsigns")
    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = buf, desc = desc })
    end
    map("n", "]h", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gs.nav_hunk("next")
      end
    end, "Next Hunk")
    map("n", "[h", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gs.nav_hunk("prev")
      end
    end, "Prev Hunk")
    map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
    map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
    map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
    map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
    map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
    map("n", "<leader>ghb", function()
      gs.blame_line({ full = true })
    end, "Blame Line")
    map("n", "<leader>ghB", gs.blame, "Blame Buffer")
    map("n", "<leader>ghd", gs.diffthis, "Diff This")
    map({ "o", "x" }, "ih", gs.select_hunk, "Select Hunk")
  end,
})

--
-- fzf-lua
--
require("fzf-lua").setup({
  fzf_colors = true, -- derive fzf's colors from the nvim colorscheme
  defaults = { file_icons = false, git_icons = false },
  files = { cmd = "fd --type f --hidden --follow --exclude .git" },
  grep = { rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --glob=!.git/" },
})
require("fzf-lua").register_ui_select()

--
-- claudecode.nvim: its WebSocket server (an editor-control endpoint for
-- Claude Code) only runs after the first <leader>a* mapping in a session.
--
local claude_started = false
local function claude(cmd)
  return function()
    if not claude_started then
      require("claudecode").setup({})
      claude_started = true
    end
    vim.cmd(cmd)
  end
end
vim.keymap.set("n", "<leader>ac", claude("ClaudeCode"), { desc = "Toggle Claude" })
vim.keymap.set("n", "<leader>af", claude("ClaudeCodeFocus"), { desc = "Focus Claude" })
vim.keymap.set("n", "<leader>ar", claude("ClaudeCode --resume"), { desc = "Resume Claude" })
vim.keymap.set("n", "<leader>aC", claude("ClaudeCode --continue"), { desc = "Continue Claude" })
vim.keymap.set("n", "<leader>ab", claude("ClaudeCodeAdd %"), { desc = "Add current buffer" })
vim.keymap.set("x", "<leader>as", claude("ClaudeCodeSend"), { desc = "Send to Claude" })
vim.keymap.set("n", "<leader>aa", claude("ClaudeCodeDiffAccept"), { desc = "Accept diff" })
vim.keymap.set("n", "<leader>ad", claude("ClaudeCodeDiffDeny"), { desc = "Deny diff" })
