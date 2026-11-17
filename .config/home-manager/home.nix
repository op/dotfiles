# Packages only: the config files themselves are tracked in the dotfiles git
# repo (~/.dotgit), so no programs.* modules are enabled here; they would try
# to write the same files.
{ pkgs, username, dolly, ... }:
let
  # Tree-sitter grammars + queries for neovim, built by nix (hash-pinned via
  # flake.lock) instead of nvim-treesitter downloading and compiling them at
  # runtime. Linked into share/nvim/site, which nvim picks up from
  # XDG_DATA_DIRS (~/.nix-profile/share). c, lua, markdown, query, vim and
  # vimdoc ship with nvim itself, so they're deliberately not listed here.
  treesitterLanguages = [
    "bash"
    "diff"
    "dockerfile"
    "git_config"
    "git_rebase"
    "gitcommit"
    "gitignore"
    "go"
    "gomod"
    "gosum"
    "gotmpl" # inherited by helm
    "gowork"
    "helm" # helm chart templates (go templates + yaml)
    "json"
    "make"
    "python"
    "regex"
    "rust"
    "toml"
    "yaml"
  ];
  nvim-treesitter-site =
    let
      ts = pkgs.vimPlugins.nvim-treesitter;
      link = lang: ''
        ln -s ${ts.grammarPlugins.${lang}}/parser/${lang}.so $site/parser/${lang}.so
        ln -s ${ts}/runtime/queries/${lang} $site/queries/${lang}
      '';
    in
    pkgs.runCommand "nvim-treesitter-site" { } ''
      site=$out/share/nvim/site
      mkdir -p $site/parser $site/queries
      ${pkgs.lib.concatMapStrings link treesitterLanguages}
    '';
  # `git dolly <url>` clones into ~/src/<host>/<path> (override with DOLLY_PATH)
  dolly-bin = pkgs.stdenvNoCC.mkDerivation {
    pname = "dolly";
    version = dolly.shortRev or "unstable";
    src = dolly;
    buildInputs = [ pkgs.python3 ]; # patchShebangs picks this python
    dontBuild = true;
    installPhase = ''
      install -Dm755 dolly $out/bin/dolly
      ln -s dolly $out/bin/git-dolly
    '';
  };
in
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  # weekly systemd user timer: drop home-manager generations older than 30
  # days, then collect unreferenced store paths
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };

  home.packages = with pkgs; [
    # dotfiles bootstrap (`mr checkout` fetches zplug and themes)
    mr # myrepos
    git
    git-lfs # ~/.config/git/hooks/pre-push

    # shell
    zsh
    starship
    tmux
    fzf
    direnv

    # neovim (replaces bob: the version is pinned by flake.lock instead)
    neovim
    nvim-treesitter-site

    # Base versions of the language servers nvim starts. Projects can still
    # pin their own: rust-analyzer/rustfmt come from rustup (rust-toolchain.toml),
    # and nvim prefers a project's .venv/bin/ruff over this one in trusted roots.
    gopls
    pyright
    ruff
    lua-language-server
    taplo # toml
    stylua

    mold # linker

    lazygit # nvim <leader>gg
    glow # nvim :Glow

    # cli tools referenced by the configs
    bat
    delta
    eza
    fd
    ripgrep
    colordiff
    jq
    dolly-bin
  ];
}
