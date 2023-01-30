# Add local executables to path

GOVERSION=go1.16.6
source ~/src/github.com/northvolt/tools/etc/etc.sh
source "$HOME/.config/environment.d/path.conf"
source "$HOME/.cargo/env"
export PATH

## pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PATH:$PYENV_ROOT/bin"

## XDG Base Directory spec
# https://wiki.archlinux.org/title/XDG_Base_Directory#User_directories
export XDG_CACHE_HOME="${XDG_CACHE_HOME-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME-$HOME/.local/share}"

# user
export XDG_STATE_HOME="${XDG_STATE_HOME-$HOME/.local/state}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR-/tmp/run.user-$(id -u)}"
# system
export XDG_DATA_DIRS="${XDG_DATA_DIRS-/usr/local/share/:/usr/share/}"
export XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS-/etc/xdg}"

## XDG User directories
[ -r "$XDG_CONFIG_HOME/user-dirs.dirs" ] && . "$XDG_CONFIG_HOME/user-dirs.dirs"
export XDG_DESKTOP_DIR="${XDG_DESKTOP_DIR-$HOME/Desktop}"
export XDG_DOCUMENTS_DIR="${XDG_DOCUMENTS_DIR-$HOME/Documents}"
export XDG_DOWNLOAD_DIR="${XDG_DOWNLOAD_DIR-$HOME/Downloads}"
export XDG_MUSIC_DIR="${XDG_MUSIC_DIR-$HOME/Music}"
export XDG_PICTURES_DIR="${XDG_PICTURES_DIR-$HOME/Pictures}"
export XDG_PUBLICSHARE_DIR="${XDG_PUBLICSHARE_DIR-$HOME/Public}"
export XDG_TEMPLATES_DIR="${XDG_TEMPLATES_DIR-$HOME/Templates}"
export XDG_VIDEOS_DIR="${XDG_VIDEOS_DIR-$HOME/Videos}"

# Preferences
export BROWSER=browser-work
export EDITOR=nvim
export SHELL=zsh
export TERMINAL=alacritty

# https://wiki.archlinux.org/title/Wayland#GUI_libraries
export CLUTTER_BACKEND=wayland
export ECORE_EVAS_ENGINE=wayland-egl
export ELM_ENGINE=wayland_egl
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=qt5ct
# https://wiki.archlinux.org/title/Firefox#Applications_on_Wayland_can_not_launch_Firefox
# export MOZ_DBUS_REMOTE=1
# https://github.com/swaywm/sway/wiki#disabling-client-side-qt-decorations
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway
# https://github.com/swaywm/sway/wiki#issues-with-java-applications
export _JAVA_AWT_WM_NONREPARENTING=1

# Clutter applications hang at startup (eg gnome-control-center)
# https://github.com/swaywm/sway/issues/4398
export CLUTTER_BACKEND=gdk

# QT settings
#export QT_PLUGIN_PATH=/usr/lib/qt/plugins
#export QT_WAYLAND_FORCE_DPI=physical
# https://github.com/FedoraQt/QGnomePlatform
#export QT_QPA_PLATFORMTHEME='gnome'

# FIXME: keyring-daemon is already started through systemd
#[ -n "$DISPLAY" ] && export $(gnome-keyring-daemon --start)

# gnome-keyring-daemon is started through systemd and socket activation
[ -n "$DISPLAY" ] && export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/keyring/ssh
