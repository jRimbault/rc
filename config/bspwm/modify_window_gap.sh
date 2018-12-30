#!/bin/bash

current_desktop=$(bspc query -T -m -d | jshon -e name | tr -d '"')
current_padding=$(bspc query -T -m -d | jshon -e padding | jshon -e right)
current_window_gap=$(bspc query -T -m -d | jshon -e windowGap)

function modify_window_gap() {
	case $1 in
		minus)
			echo $((current_window_gap - 2))
			;;
		plus)
			echo $((current_window_gap + 2))
			;;
	esac
}

bspc config -d "$current_desktop" window_gap "$(modify_window_gap $1)"