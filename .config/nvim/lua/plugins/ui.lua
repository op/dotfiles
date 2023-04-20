return {
  -- notify and noice is a distraction
  { "rcarriga/nvim-notify", enabled = false },
  { "folke/noice.nvim", enabled = false },

  -- bufferline does not align with vim
  { "akinsho/bufferline.nvim", enabled = false },

  -- blank line is ok but makes buffer navigation super slow
  { "lukas-reineke/indent-blankline.nvim", enabled = false },
  -- indent scope animates indentation and is amazing, but a performance hog
  { "echasnovski/mini.indentscope", enabled = false },

  -- disable icons in statusbar and winbar
  { "SmiteshP/nvim-navic", enabled = false },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "lewis6991/gitsigns.nvim",
    },
    opts = function()
      return {
        options = {
          component_separators = "",
          section_separators = "",
          icons_enabled = false,
        },
        sections = {
          -- git branch
          lualine_b = {
            { "b:gitsigns_head" },
          },
          -- show relative path
          lualine_c = {
            { "filename", path = 1 },
            { "filetype" },
          },
          -- disable encoding, fileformat and filetype
          lualine_x = {
            { "diff" },
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = { error = " ", warn = " ", info = " " },
            },
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

  -- add telescope-fzf-native
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },
}
