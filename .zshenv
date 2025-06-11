### XDG Base Directory spec
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
if command -v xdg-user-dir >/dev/null; then
  export XDG_DESKTOP_DIR=$(xdg-user-dir DESKTOP)
  export XDG_DOCUMENTS_DIR=$(xdg-user-dir DOCUMENTS)
  export XDG_DOWNLOAD_DIR=$(xdg-user-dir DOWNLOAD)
  export XDG_MUSIC_DIR=$(xdg-user-dir MUSIC)
  export XDG_PICTURES_DIR=$(xdg-user-dir PICTURES)
  export XDG_PUBLICSHARE_DIR=$(xdg-user-dir PUBLICSHARE)
  export XDG_TEMPLATES_DIR=$(xdg-user-dir TEMPLATES)
  export XDG_VIDEOS_DIR=$(xdg-user-dir VIDEOS)
else
  export XDG_DESKTOP_DIR="$$HOME/.desktop"
  export XDG_DOCUMENTS_DIR="$$HOME/doc"
  export XDG_DOWNLOAD_DIR="$HOME/var/download"
  export XDG_MUSIC_DIR="$HOME/doc/sound"
  export XDG_PICTURES_DIR="$HOME/doc/pictures"
  export XDG_PUBLICSHARE_DIR="$HOME/var/public"
  export XDG_TEMPLATES_DIR="$HOME/.xdg-template"
  export XDG_VIDEOS_DIR="$HOME/doc/video"
fi

# grimshot supports XDG_SCREENSHOTS_DIR
export XDG_SCREENSHOTS_DIR="$XDG_PICTURES_DIR/screenshots"

### flatpak
export XDG_DATA_DIRS="$XDG_DATA_DIRS:$XDG_DATA_HOME/flatpak/exports/share"

### path
source "$HOME/.config/environment.d/path.conf"
[[ -s "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
if [[ -d ~/src/github.com/northvolt/tools ]]; then
  export PATH=$PATH:$HOME/src/github.com/northvolt/tools/bin
fi
export PATH=$PATH:$HOME/var/sync/base/bin

### go
export GOPATH=$HOME
if [[ -d ~/src/github.com/northvolt/tools ]]; then
  source ~/src/github.com/northvolt/tools/etc/etc.d/goproxy.sh
fi

### zig
if [[ -d ~/.zigenv ]]; then
  export ZIGENV_ROOT=$HOME/.zigenv
  export PATH=$ZIGENV_ROOT/bin:$ZIGENV_ROOT/shims:$PATH
fi

### pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PATH:$PYENV_ROOT/bin"

### terraform and terragrunt version managers
[[ ! -d ~/.tfenv/bin ]] || export PATH="$HOME/.tfenv/bin:$PATH"
[[ ! -d ~/.tgenv/bin ]] || export PATH="$HOME/.tgenv/bin:$PATH"

### debian
export DEBFULLNAME="Örjan Persson"
export DEBEMAIL="orange@fobie.net"
export QUILT_PATCHES=debian/patches

# if [[ -x ~/src/go.googlesource.com/go/bin/go ]]; then
	# export PATH=$HOME/src/go.googlesource.com/go/bin:$PATH
# fi

### python
if [[ -d ~/lib/python ]]; then
  export PYTHONPATH=~/lib/python:$PYTHONPATH
fi

### ruby
export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH

### javascript
#export PATH=~/.npm-global/bin:$PATH

### fastlane via cask
[[ ! -d ~/.fastlane/bin ]] || export PATH=$HOME/.fastlane/bin:$PATH

### java
# export JDK_HOME=/usr/lib/jvm/default-java
# export JAVA_HOME=$JDK_HOME
# export M2_HOME=/usr/share/maven
# export M2_HOME=~/src/vanilla/maven/apache-maven-3.1.1
# export PATH=~/src/vanilla/maven/apache-maven-3.1.1/bin:$PATH

# HACK: make sure we use the Java version installed with Android Studio
if [[ -d ~/var/android/android-studio/jre/bin ]]; then
  export PATH=$HOME/var/android/android-studio/jre/bin:$PATH
fi

# ### android
# if [[ -d $HOME/var/android/android-studio/sdk ]]; then
#     export ANDROID_HOME=$HOME/var/android/android-studio/sdk
# elif [[ -d /usr/lib/android-sdk ]]; then
#     export ANDROID_HOME=/usr/lib/android-sdk
# fi

export ANDROID_SDK_ROOT=$HOME/sdk/android
export ANDROID_HOME=$ANDROID_SDK_ROOT

if [[ -d $ANDROID_HOME/emulator ]]; then
  export PATH=$PATH:$ANDROID_HOME/emulator
fi
if [[ -d $ANDROID_HOME/tools/bin ]]; then
  export PATH=$PATH:$ANDROID_HOME/tools/bin
fi
if [[ -d $ANDROID_HOME/platform-tools ]]; then
  export PATH=$PATH:$ANDROID_HOME/platform-tools
fi

# if [[ -d $HOME/var/android/android-studio/jre/jre ]]; then
#     export JAVA_HOME=$HOME/var/android/android-studio/jre/jre
# fi

# if [[ -d $HOME/lib/android/android-ndk-r9b ]]; then
#     export ANDROID_NDK=$HOME/lib/android/android-ndk-r9b
# elif [[ -d /usr/lib/android-ndk ]]; then
#     export ANDROID_NDK=/usr/lib/android-ndk
# fi

# if [[ -x $HOME/var/android/android-studio/sdk/platform-tools ]]; then
#     export PATH=$HOME/var/android/android-studio/sdk/platform-tools:$PATH
# fi

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

# export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
# gnome-keyring-daemon is started through systemd and socket activation
#[ -n "$DISPLAY" ] && export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/keyring/ssh

# aws tooling granted.dev/
alias assume="source assume"
alias dassume="source dassume"
fpath=(~/.granted/zsh_autocomplete/assume/ $fpath)
fpath=(~/.granted/zsh_autocomplete/granted/ $fpath)

# k8s
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
