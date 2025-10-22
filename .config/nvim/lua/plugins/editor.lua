return {
  -- { "nvim-neo-tree/neo-tree.nvim", enabled = false },

  -- working with big files
  -- TODO: see ui.lua too
  { "pteroctopus/faster.nvim" },
  --{ "LunarVim/bigfile.nvim" },

  -- {
  --   "linux-cultist/venv-selector.nvim",
  --   branch = "regexp", -- Use this branch for the new version
  --   cmd = "VenvSelect",
  --   enabled = true,
  --   dependencies = {
  --     "mason-org/mason.nvim",
  --     "mason-org/mason-lspconfig.nvim",
  --   },
  --   opts = {
  --     settings = {
  --       options = {
  --         notify_user_on_venv_activation = true,
  --       },
  --     },
  --   },
  --   --  Call config for python files and load the cached venv automatically
  --   ft = "python",
  --   keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
  -- },
}
