# modal specific bash configuration

# continue if we're in modal context and ec2
instance_id=$(cat /sys/devices/virtual/dmi/id/board_asset_tag)
if [[ ! -d ~/modal || ! "$instance_id" =~ [^i-] ]]; then
  return 0 2>/dev/null
fi

# nix; the installer hooks /etc/bash.bashrc, this covers shells that skip it
if [[ -z "${NIX_PROFILES:-}" && -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
  source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# rust toolchain for the modal repo (rustup)
[[ ! -s "$HOME/.cargo/env" ]] || source "$HOME/.cargo/env"

# dotfiles
alias dot='git --work-tree $HOME --git-dir $HOME/.dotgit'

# starship
command -v starship >/dev/null && eval "$(starship init bash)"

which eza >/dev/null && alias lz=eza
which bat >/dev/null && alias cat=bat
