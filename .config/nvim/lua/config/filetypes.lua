-- Filetype detection that nvim doesn't ship.

-- Helm chart templates: Go templates wrapped around YAML. As plain "yaml"
-- the {{ ... }} parts break the parser and highlighting; the "helm" grammar
-- (from nix) parses the template syntax and injects yaml for the rest.
-- Only files under <chart>/templates/ next to a Chart.yaml count.
local function helm_template(path)
  local chart = path:match("^(.*)/templates/")
  if chart and vim.uv.fs_stat(chart .. "/Chart.yaml") then
    return "helm"
  end
end

vim.filetype.add({
  pattern = {
    [".*/templates/.*%.ya?ml"] = { helm_template, { priority = 10 } },
    [".*/templates/.*%.tpl"] = { helm_template, { priority = 10 } },
    [".*/templates/.*%.txt"] = { helm_template, { priority = 10 } }, -- NOTES.txt
  },
})
