return {
  -- tweak snacks.nvim
  -- {
  --   "folke/snacks.nvim",
  --   opts = {
  --     -- disable indent guide -- too slow
  --     indent = { enabled = false },
  --   },
  -- },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      return {
        options = {
          -- theme = "catppuccin",
          component_separators = "",
          section_separators = "",
          -- icons_enabled = false,
        },
        sections = {
          -- disable git branch
          lualine_b = {},
          -- show relative path
          lualine_c = {
            { "filename", path = 1 },
            --{ "filetype" },
          },
          -- disable encoding, fileformat and filetype
          lualine_x = {
            { "diff" },
            { "diagnostics" },
          },
          -- disable progress
          lualine_y = {},
        },
        inactive_sections = {
          -- show relative path
          lualine_c = { { "filename", path = 1 } },
          -- disable progress
          lualine_y = {},
        },
      }
    end,
  },
}
