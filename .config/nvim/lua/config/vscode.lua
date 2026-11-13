-- Selected settings from a project's .vscode/settings.json for LSP servers.
--
-- Two layers, both required:
--  1. File trust: vim.secure.read() prompts once per file content (SHA-256
--     in ~/.local/state/nvim/trust); any change to the file prompts again.
--     Manage with `:trust`, `:trust ++deny`, `:trust ++remove <file>`.
--  2. Key allowlist: only the keys below are applied, with their values
--     validated. Anything that can name a command, binary, env var or
--     wrapper is rejected even in a trusted file, because e.g.
--     `rust-analyzer.check.extraArgs = ["--config", "build.rustc-wrapper=..."]`
--     or `*.overrideCommand` is code execution.
-- Callers only run inside trusted roots (lua/config/trust.lua).
local M = {}

local function is_list_of(pattern)
  return function(v)
    if not vim.islist(v) then
      return false
    end
    for _, s in ipairs(v) do
      if type(s) ~= "string" or not s:match(pattern) then
        return false
      end
    end
    return true
  end
end

local function is(t)
  return function(v)
    return type(v) == t
  end
end

local function is_scalar(v)
  local t = type(v)
  return t == "boolean" or t == "number" or t == "string"
end

-- Exact keys -> validator.
local allowed_keys = {
  ["rust-analyzer.check.workspace"] = is("boolean"),
  ["rust-analyzer.check.allTargets"] = is("boolean"),
  ["rust-analyzer.cargo.allTargets"] = is("boolean"),
  ["rust-analyzer.cargo.noDefaultFeatures"] = is("boolean"),
  ["rust-analyzer.cargo.features"] = function(v)
    return v == "all" or is_list_of("^[%w_%-/]+$")(v)
  end,
  -- Toolchain selection only, e.g. "+nightly-2026-08-23".
  ["rust-analyzer.rustfmt.extraArgs"] = is_list_of("^%+[%w%._%-]+$"),
}

-- Key prefixes whose leaves may be any scalar (or list/map of scalars).
-- These only tune diagnostics / UI / analysis, never what gets executed.
local allowed_prefixes = {
  "rust-analyzer.diagnostics.",
  "rust-analyzer.inlayHints.",
  "rust-analyzer.completion.",
  "rust-analyzer.imports.",
  "rust-analyzer.hover.",
  "rust-analyzer.lens.",
  "rust-analyzer.semanticHighlighting.",
  "python.analysis.",
}

-- Never applied, whatever the prefix.
local denied_words = { "command", "env", "server", "wrapper", "executable", "interpreter", "binary" }

local function is_leaf_ok(v)
  if is_scalar(v) then
    return true
  end
  if type(v) == "table" then
    for _, x in pairs(v) do
      if not is_scalar(x) then
        return false
      end
    end
    return true
  end
  return false
end

local function check(key, value)
  local lower = key:lower()
  for _, word in ipairs(denied_words) do
    if lower:find(word, 1, true) then
      return false
    end
  end
  if allowed_keys[key] then
    return allowed_keys[key](value)
  end
  for _, prefix in ipairs(allowed_prefixes) do
    if vim.startswith(key, prefix) then
      return is_leaf_ok(value)
    end
  end
  return false
end

-- VS Code accepts both "a.b.c": v and "a": { "b": { "c": v } }.
local function flatten(tbl, prefix, out)
  for k, v in pairs(tbl) do
    if type(k) == "string" and not k:match("^%[") then -- skip "[python]" language blocks
      local key = prefix and (prefix .. "." .. k) or k
      local is_map = type(v) == "table" and not vim.islist(v) and next(v) ~= nil
      if is_map and not allowed_keys[key] and not key:match("^python%.analysis%.[^.]+$") then
        flatten(v, key, out)
      else
        out[key] = v
      end
    end
  end
  return out
end

local function set_path(tbl, key, value)
  -- Split on "." but keep "rust-analyzer" as one segment.
  local parts = vim.split(key, ".", { plain = true })
  local node = tbl
  for i = 1, #parts - 1 do
    node[parts[i]] = node[parts[i]] or {}
    node = node[parts[i]]
  end
  node[parts[#parts]] = value
end

local reported = {}

--- Allowed settings under `section` (e.g. "rust-analyzer", "python") from
--- .vscode/settings.json in `root` or its git root. Prompts for trust.
---@param root string
---@param section string
---@return table
function M.settings(root, section)
  local result = {}
  local dirs = { root }
  local git_root = vim.fs.root(root, { ".git" })
  if git_root and git_root ~= root then
    table.insert(dirs, 1, git_root) -- deeper settings file wins
  end
  for _, dir in ipairs(dirs) do
    local path = dir .. "/.vscode/settings.json"
    if vim.uv.fs_stat(path) then
      local content = vim.secure.read(path)
      if content then
        local ok, data = pcall(vim.json.decode, content, { skip_comments = true, luanil = { object = true } })
        if ok and type(data) == "table" then
          local applied, ignored = {}, {}
          for key, value in pairs(flatten(data, nil, {})) do
            if vim.startswith(key, section .. ".") then
              if check(key, value) then
                set_path(result, key, value)
                table.insert(applied, key)
              else
                table.insert(ignored, key)
              end
            end
          end
          local id = path .. section
          if not reported[id] and (#applied + #ignored) > 0 then
            reported[id] = true
            table.sort(applied)
            table.sort(ignored)
            local msg = ("%s (%s)\n  applied: %s"):format(path, section, table.concat(applied, ", "))
            if #ignored > 0 then
              msg = msg .. "\n  ignored: " .. table.concat(ignored, ", ")
            end
            vim.notify(msg, #ignored > 0 and vim.log.levels.WARN or vim.log.levels.INFO)
          end
        else
          vim.notify("Could not parse " .. path, vim.log.levels.WARN)
        end
      end
    end
  end
  return result
end

--- before_init helper: merge project settings over the config's settings.
---@param section string
function M.before_init(section)
  return function(_, config)
    local project = M.settings(config.root_dir, section)
    if next(project) then
      config.settings = vim.tbl_deep_extend("force", config.settings or {}, project)
    end
  end
end

return M
