#!/usr/bin/env bash

status=$(nmcli n)

case $status in
    enabled)
        nmcli n off
        ;;
    disabled)
        nmcli n on
        ;;
esac

popup.sh switch_wifi
