return {
  -- disable automatic insertion of pairs like parenthesis etc
  { "echasnovski/mini.pairs", enabled = false },

  -- markdown preview, use :Glow to open preview within nvim.
  { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },

  -- markdown preview, use :MarkdownPreview to preview in browser.
  {
    "iamcco/markdown-preview.nvim",
    config = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  -- enable direnv within nvim
  { "direnv/direnv.vim", lazy = false, priority = 900 },
}
