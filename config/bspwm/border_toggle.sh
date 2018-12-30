#!/bin/bash


# borderWidth
change_border_width() {
	current_border=$(bspc query -T -m -d | jshon -e borderWidth)
	if [[ $current_border -eq "0" ]]; then
		bspc config -d $1 border_width 16
	else
		bspc config -d $1 border_width 1
	fi
}

current_desktop=$(bspc query -T -m -d | jshon -e name | tr -d '"')
change_border_width $current_desktop
