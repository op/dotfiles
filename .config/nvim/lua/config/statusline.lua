-- Small native statusline (replaces lualine): relative path, git diff
-- counts (gitsigns), diagnostics, position. Only visible with laststatus > 0.

function _G.user_statusline()
  local parts = { " %<%f %h%m%r" }
  local git = vim.b.gitsigns_status_dict
  if git then
    local diff = {}
    for key, sign in pairs({ added = "+", changed = "~", removed = "-" }) do
      if (git[key] or 0) > 0 then
        table.insert(diff, sign .. git[key])
      end
    end
    table.sort(diff)
    if #diff > 0 then
      table.insert(parts, " " .. table.concat(diff, " "))
    end
  end
  table.insert(parts, "%=")
  table.insert(parts, vim.diagnostic.status())
  table.insert(parts, "  %l:%c ")
  return table.concat(parts)
end

vim.o.statusline = "%!v:lua.user_statusline()"
