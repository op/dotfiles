#!/bin/bash
# Install Nix and the packages in ~/.config/home-manager, then fetch the repos
# listed in ~/.config/mr. Safe to re-run.
#
# Trust chain: the Nix installer is pinned by version and sha256 below; it
# embeds the sha256 of the Nix tarball it downloads. nixpkgs and home-manager
# are pinned by ~/.config/home-manager/flake.lock, and binaries from
# cache.nixos.org are checked against its signing key.
#
# To bump Nix: pick a release from https://releases.nixos.org/?prefix=nix/,
# download nix-<version>/install, review it, and update both values.
set -euo pipefail

NIX_VERSION=2.35.6
NIX_INSTALL_SHA256=6f7bf206efb54cd4941fb274930dbc74fdfc16fcb06757ef261c8d7d69cfd60e

# provisioned ~/.gitconfig would override ~/.config/git/config
mv "$HOME/.gitconfig" "$HOME/.gitconfig.$(date +%Y%m%d%H%M%S)" 2>/dev/null || true

if [ ! -d /nix ]; then
	tmp=$(mktemp -d)
	trap 'rm -rf "$tmp"' EXIT
	curl -sSfL --proto '=https' --tlsv1.2 \
		"https://releases.nixos.org/nix/nix-$NIX_VERSION/install" -o "$tmp/install"
	echo "$NIX_INSTALL_SHA256  $tmp/install" | sha256sum --check --strict
	sh "$tmp/install" --daemon --yes
fi

set +u # nix-daemon.sh references unset variables
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
set -u

hm="$HOME/.config/home-manager"
if command -v home-manager >/dev/null; then
	home-manager switch --flake "$hm"
else
	# --inputs-from resolves `home-manager` to the version in flake.lock
	nix --extra-experimental-features 'nix-command flakes' \
		run --inputs-from "$hm" home-manager -- switch --flake "$hm"
fi

cd "$HOME" && mr checkout
