return {
  -- disable automatic insertion of pairs like parenthesis etc
  { "echasnovski/mini.pairs", enabled = false },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.completion = {
        completeopt = vim.o.completeopt,
      }
      opts.experimental = {
        ghost_text = false,
      }
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "emoji" },
      }))
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<CR>"] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace }),
      })
    end,
  },
}
