# PATH is configured in systemd user's environment.d instead to make a
# consistent experience in Wayland and shell.
#
# In Debian, /etc/profile is sourced after which overwrites the PATH. Let's
# give it another try to set the PATH here then.
# https://github.com/systemd/systemd/issues/6414
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=869144
source "$HOME/.config/environment.d/path.conf"
export PATH
