# nvim

Native-first Neovim (>= 0.12) config. No distribution, no Mason, no runtime
downloads besides three pinned Lua plugins.

## Where things come from

| What | Source | Pinned by |
| --- | --- | --- |
| neovim | nix (`~/.config/home-manager/home.nix`) | `flake.lock` |
| tree-sitter parsers + queries | nix (`nvim-treesitter-site` in `home.nix`) | `flake.lock` |
| gopls, pyright, ruff, lua-language-server, taplo, stylua, lazygit, glow, fzf, fd, rg | nix | `flake.lock` |
| rust-analyzer, rustfmt | rustup, per project `rust-toolchain.toml` | the project |
| ruff (project override) | `<root>/.venv/bin/ruff` if present | the project |
| plugins: gitsigns, fzf-lua, claudecode | `vim.pack` | `nvim-pack-lock.json` (commit SHAs) |
| colorscheme | builtin `catppuccin` | neovim |

Nix provides a base version of each tool. Where the version affects output
(formatters, rust-analyzer vs. the compiler), the project's own pin wins.

## Security model

* **LSPs start only in trusted roots** (`lua/config/trust.lua`: `~/modal`,
  `~/src`, `~/.config`). Language servers run project code (proc macros, build
  scripts, venv interpreters), so other checkouts get plain editing only.
  `:Trust [dir]` trusts a directory for the current session.
* No project-local config is executed: `exrc` is off, no neoconf.
  `.vscode/settings.json` is only read after you trust it (`vim.secure`,
  re-prompted whenever the file changes; see `:trust`), and then only
  allowlisted rust-analyzer / `python.analysis` keys are applied. Anything
  naming a command, env var, wrapper or binary is dropped
  (`lua/config/vscode.lua`); applied and ignored keys are reported.
* Modelines are disabled. netrw, zip/tar and the remote-plugin providers are off.
* Sensitive files (`.env`, keys, `~/.ssh`, `~/.aws`, `/dev/shm`, `/tmp`, ...)
  get no swap, undo, backup or shada, and the clipboard is disconnected while
  one is focused. Shada never stores register contents.
* State dirs under `~/.local/state/nvim` are kept at mode 0700.
* claudecode.nvim's WebSocket server only starts after the first `<leader>a*`
  mapping.

## Common tasks

* Add a language: add the grammar to `treesitterLanguages` and the server to
  `home.packages` in `home.nix`, then `home-manager switch`. Add
  `lsp/<name>.lua` (use `trust.root_dir`) and add the server to `vim.lsp.enable` in
  `lua/config/lsp.lua`.
* New rust toolchain: `rustup component add rust-analyzer --toolchain <channel>`.
* Update plugins: `:lua vim.pack.update()`, review the diff, `:w` to apply, then
  `dot add ~/.config/nvim/nvim-pack-lock.json && dot commit`.
* Update everything else: `nix flake update` in `~/.config/home-manager`.
* Check what's running: `:checkhealth vim.lsp`, `:checkhealth vim.pack`.
