-- Native treesitter. Parsers and queries come from nix
-- (~/.nix-profile/share/nvim/site, see ~/.config/home-manager/home.nix) or
-- ship with nvim; nothing is downloaded or compiled here. To add a language,
-- add it to `treesitterLanguages` in home.nix.

-- nvim finds this via XDG_DATA_DIRS when nix's profile script ran, but not
-- e.g. when started from a launcher; add it explicitly.
local nix_site = vim.fn.expand("~/.nix-profile/share/nvim/site")
if vim.uv.fs_stat(nix_site) and not vim.tbl_contains(vim.opt.runtimepath:get(), nix_site) then
  vim.opt.runtimepath:append(nix_site)
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
  callback = function(ev)
    if vim.b[ev.buf].bigfile then
      -- :syntax on's own FileType handler runs after this one; undo it.
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(ev.buf) then
          vim.bo[ev.buf].syntax = "off"
        end
      end)
      return
    end
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not lang or not vim.treesitter.language.add(lang) then
      return
    end
    if not pcall(vim.treesitter.start, ev.buf, lang) then
      return
    end
    for _, win in ipairs(vim.fn.win_findbuf(ev.buf)) do
      vim.wo[win][0].foldmethod = "expr"
      vim.wo[win][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end
  end,
})
