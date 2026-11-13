-- General autocmds (security-related ones live in security.lua).
local group = vim.api.nvim_create_augroup("user_autocmds", { clear = true })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Go back to the last cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  callback = function(ev)
    if vim.tbl_contains({ "gitcommit", "gitrebase" }, vim.bo[ev.buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Resize splits when the terminal is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = group,
  command = "tabdo wincmd =",
})

-- Prose filetypes: wrap and spell
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "text", "markdown", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
