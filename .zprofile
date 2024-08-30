# launch sway from login shell
if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
    command -v sway >/dev/null || return
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM=wayland
    export QT_QPA_PLATFORMTHEME=qt5ct
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=sway
    export _JAVA_AWT_WM_NONREPARENTING=1

    # gnome-keyring-daemon is deprecated and will be replaced with gcr.
    #
    # These lines are copied from
    # /usr/lib/systemd/user/gnome-keyring-ssh.service
    export eval $(gnome-keyring-daemon --start --components ssh,secrets,pkcs11)
    dbus-update-activation-environment --verbose --systemd \
      SSH_AUTH_SOCK=$SSH_AUTH_SOCK SSH_AGENT_LAUNCHER=gnome-keyring

    # * with this, screensharing doesn't work
    exec sway
    # * with this
    #exec dbus-run-session sway
    # * with this, snap doesn't work (multiple dbus)
    #exec dbus-launch --sh-syntax --exit-with-session sway
elif [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty2" ]; then
    command -v gnome-shell >/dev/null || return
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM=wayland
    export QT_QPA_PLATFORMTHEME=qt5ct
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=gnome
    exec gnome-shell --wayland
fi
