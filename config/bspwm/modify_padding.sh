#!/bin/bash

current_desktop=$(bspc query -T -m -d | jshon -e name | tr -d '"')

function padding() {
	case $2 in
		minus)
			echo $(($1 - 6))
			;;
		plus)
			echo $(($1 + 6))
			;;
	esac
}

function side() {
	case $1 in
		right)
			current_padding=$(bspc query -T -m -d | jshon -e padding | jshon -e right)
			new_padding=$(padding $current_padding $2)
			bspc config -d $current_desktop right_padding $new_padding
			;;
		left)
			current_padding=$(bspc query -T -m -d | jshon -e padding | jshon -e left)
			new_padding=$(padding $current_padding $2)
			bspc config -d $current_desktop left_padding $new_padding
			;;
		top)
			current_padding=$(bspc query -T -m -d | jshon -e padding | jshon -e top)
			new_padding=$(padding $current_padding $2)
			bspc config -d $current_desktop top_padding $new_padding
			;;
		bottom)
			current_padding=$(bspc query -T -m -d | jshon -e padding | jshon -e bottom)
			new_padding=$(padding $current_padding $2)
			bspc config -d $current_desktop bottom_padding $new_padding
			;;
	esac
}

side $1 $2

# bspc config -d $current_desktop top_padding $amount