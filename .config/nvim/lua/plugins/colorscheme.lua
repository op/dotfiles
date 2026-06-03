return {
  -- { "rose-pine/neovim", name = "rose-pine", opts = { dark_variant = "main" } },
  { "catppuccin/nvim", name = "catppuccin" },
  -- { "LazyVim/LazyVim", opts = { colorscheme = "rose-pine" } },
  -- nvim 0.12 bundles a builtin `catppuccin` colorscheme, so lazy.nvim never
  -- loads the plugin under that name — use the plugin's `catppuccin-nvim`.
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin-nvim" } },
}
