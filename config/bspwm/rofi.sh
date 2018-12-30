#!/usr/bin/env bash

WIDTH=1920
LOCATION=0
LINES=7
FONT="Source Code Pro for Powerline 12"
PADDING=380
OPACITY=100

COLOR_WINDOW="#1F1F1F, #1F1F1F, #1F1F1F"
COLOR_NORMAL="#1F1F1F, #EEEEEE, #1F1F1F, #EEEEEE, #1F1F1F"
COLOR_URGENT=""
COLOR_ACTIVE="#1F1F1F"

WIDTH=720
PADDING=20

rofi='rofi -hide-scrollbar \
-color-enabled \
-location "$LOCATION" \
-lines "$LINES" \
-font "$FONT" \
-separator-style none \
-opacity "$OPACITY" \
-color-normal "$COLOR_NORMAL" \
-color-window "$COLOR_WINDOW" \
-sidebar-mode \
-padding "$PADDING" \
-width "$WIDTH"'

case $1 in
	drun)
		rofi -show drun \
			-hide-scrollbar \
			-color-enabled \
			-location "$LOCATION" \
			-lines "$LINES" \
			-font "$FONT" \
			-separator-style none \
			-opacity "$OPACITY" \
			-color-normal "$COLOR_NORMAL" \
			-color-window "$COLOR_WINDOW" \
			-sidebar-mode \
			-padding "$PADDING" \
			-width "$WIDTH"
		;;
	ssh)
		rofi -show ssh \
			-hide-scrollbar \
			-color-enabled \
			-location "$LOCATION" \
			-lines "$LINES" \
			-font "$FONT" \
			-separator-style none \
			-opacity "$OPACITY" \
			-color-normal "$COLOR_NORMAL" \
			-color-window "$COLOR_WINDOW" \
			-sidebar-mode \
			-padding "$PADDING" \
			-width "$WIDTH"
		;;
	test)
		rofi=$rofi" -show ssh"
		;;
esac

$rofi
#echo $rofi