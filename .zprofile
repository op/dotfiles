# launch sway from login shell
if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
    command -v sway >/dev/null || return
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM=wayland
    export QT_QPA_PLATFORMTHEME=qt5ct
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=sway
    export _JAVA_AWT_WM_NONREPARENTING=1
    exec dbus-run-session sway
elif [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty2" ]; then
    command -v gnome-shell >/dev/null || return
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM=wayland
    export QT_QPA_PLATFORMTHEME=qt5ct
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=gnome
    exec gnome-shell --wayland
fi
