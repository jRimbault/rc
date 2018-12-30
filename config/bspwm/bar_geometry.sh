#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then
	DIR="$PWD"
fi
source "$DIR/panel_colors"

function paddingRight() {
	x_right_padding=$((1920-$(($1+60))))
	echo $x_right_padding
}

function paddingBottom() {
	y_bot_padding=$((1080-$(($1+60))))
	echo $y_bot_padding
}

function TOP_RIGHT() {
	TOP_RIGHT="+$(paddingRight $1)+60"
	echo $TOP_RIGHT
}

function WRKSPACES() {
	TOP_RIGHT="+$(paddingRight $1)+120"
	echo TOP_RIGHT
}

function BOT_RIGHT() {
	BOT_RIGHT="+$(paddingRight $1)+$(paddingBottom $2)"
	echo $BOT_RIGHT
}

function TOP_LEFT() {
	TOP_LEFT="+60+60"
	echo $TOP_LEFT
}

function BOT_LEFT() {
	BOT_LEFT="+60+$(paddingBottom $1)"
	echo $BOT_LEFT
}

function geometry() {
	case $1 in
		x-small)
			x_dim=60
			y_dim=60
			position $2 $x_dim $y_dim
			;;
		small)
			x_dim=100
			y_dim=60
			position $2 $x_dim $y_dim
			;;
		medium)
			x_dim=150
			y_dim=60
			position $2 $x_dim $y_dim
			;;
		large)
			x_dim=200
			y_dim=60
			position $2 $x_dim $y_dim
			;;
		x-large)
			x_dim=240
			y_dim=60
			position $2 $x_dim $y_dim
			;;
		very-large)
			x_dim=240
			y_dim=60
			position $2 $x_dim $y_dim
			;;
		workspace)
			x_dim=240
			y_dim=60
			position workspace $x_dim $y_dim
			;;
	esac
}

function position() {
	case $1 in
		top_left*)
			geometry="$2x$3$(TOP_LEFT)"
			echo $geometry
			;;
		top_right*)
			geometry="$2x$3$(TOP_RIGHT $2)"
			echo $geometry
			;;
		bot_left*)
			geometry="$2x$3$(BOT_LEFT $3)"
			echo $geometry
			;;
		bot_right*)
			geometry="$2x$3$(BOT_RIGHT $2 $3)"
			echo $geometry
			;;
		workspace*)
			geometry="$2x$3$(WRKSPACES $2 $3)"
			echo $geometry
			;;
	esac
}

# center of the screen
function center_popup() {
	x="$1"
	y="$2"
	x_center=$(( 960 - (x/2) ))
	y_center=$(( 540 - (y/2) ))
	CENTER_SCREEN="$1x$2+$x_center+$y_center"
	echo "$CENTER_SCREEN"
}
