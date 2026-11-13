#!/bin/bash
# Install Nix and the packages in ~/.config/home-manager, then fetch the repos
# listed in ~/.config/mr. Safe to re-run.
set -e

if [ ! -d /nix ]; then
	sh <(curl -sSfL https://nixos.org/nix/install) --daemon --yes
fi
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

if command -v home-manager >/dev/null; then
	home-manager switch
else
	nix run home-manager/master -- switch
fi

cd "$HOME" && mr checkout
