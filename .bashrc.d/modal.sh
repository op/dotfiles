# modal specific bash configuration

# continue if we're in modal context and ec2
instance_id=$(cat /sys/devices/virtual/dmi/id/board_asset_tag)
if [[ ! -d ~/modal || ! "$instance_id" =~ [^i-] ]]; then
	return 0 2>/dev/null
fi

# bob
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"

# dotfiles
alias dot='git --work-tree $HOME --git-dir $HOME/.dotgit'

# starship
eval "$(starship init bash)"
