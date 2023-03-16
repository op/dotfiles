#!/bin/bash

set -euo pipefail

prog=$(basename "$0")
action="${1:-help}"

case "$action" in
    start)
        notify-send -u low -t 1000 "Screen sharing started"
        makoctl set-mode do-not-disturb
        ;;
    stop)
        notify-send -u low -t 1000 "Screen sharing stopped"
        makoctl set-mode default
        ;;
    *)
        echo "Usage: $prog <start|stop>" >&2
        exit 1
        ;;
esac
