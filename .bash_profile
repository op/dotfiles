# bash login shells (e.g. ssh) read only this file, not ~/.bashrc, so pull in
# both: ~/.profile for PATH, ~/.bashrc for interactive setup (aliases etc).
[ -f "$HOME/.profile" ] && . "$HOME/.profile"
[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
