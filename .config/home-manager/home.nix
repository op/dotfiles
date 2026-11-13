# Packages only: the config files themselves are tracked in the dotfiles git
# repo (~/.dotgit), so no programs.* modules are enabled here; they would try
# to write the same files.
{ pkgs, username, ... }:
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # dotfiles bootstrap (`mr checkout` fetches zplug and themes)
    myrepos
    git

    # shell
    zsh
    starship
    tmux
    fzf
    direnv

    # neovim (replaces bob: the version is pinned by flake.lock instead)
    neovim
    # LazyVim / plugin runtime deps
    # nvim-treesitter compiles parsers with the system cc (build-essential);
    # a nix gcc on PATH would also shadow it for cargo builds in ~/modal
    tree-sitter
    lazygit # LazyVim <leader>gg
    glow # glow.nvim

    # cli tools referenced by the configs
    bat
    delta
    eza
    fd
    ripgrep
    colordiff
    jq
  ];
}
