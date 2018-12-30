#!/bin/bash


COLOR_POPUP_URGENT_FG="#fb5457"
COLOR_POPUP_URGENT_BG="#5c5c5c"

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
			x_dim=280
			y_dim=60
			position $2 $x_dim $y_dim
			;;
		xx-large)
			x_dim=520
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
	x_center=$((960-$((x/2))))
	y_center=$((540-$((y/2))))
	CENTER_SCREEN="$1x$2+$x_center+$y_center"
	echo $CENTER_SCREEN
}

#Define the battery
function getBattery() {
	bat=$(acpi --battery | cut -d, -f2 | cut -d% -f1 )
	echo $bat
	# plug f1e6
}

function batteryIcon() {
	bat=$(getBattery)
	if acpi --battery | grep 'zero rate' > /dev/null; then
		echo "\uf1e6"
	elif acpi --battery | grep 'Charging' > /dev/null; then
		echo "\uf1e6"
	elif [[ $bat > 90 ]]; then
		echo "\uf240"
	elif [[ $bat > 75 ]]; then
		echo "\uf241"
	elif [[ $bat > 45 ]]; then
		echo "\uf242"
	elif [[ $bat > 15 ]]; then
		echo "\uf243"
	else
		echo "\uf244"
	fi
}

function Clock() {
	c=$(date +%a\ %e\ %B\ %H:%M)
	echo "$c"
}

function Volume() {
	pamixer --get-volume
}

function ceiling() {
	python -c "from math import ceil; print ceil($1)"
}

function getIfMuted() {
	if [[ $(pamixer --get-mute) == "true" ]]; then
		(echo -e "%{c}\uf026"; sleep .8) | lemonbar -d -g "$(geometry small top_right)" -F "$COLOR_POPUP_FG" -B "$COLOR_POPUP_BG" -f "$SOURCE_CODE" -f "$FAWESOME" -n "noshadow"
	else
		(echo -e "%{c}\uf028"; sleep .8) | lemonbar -d -g "$(geometry small top_right)" -F "$COLOR_POPUP_FG" -B "$COLOR_POPUP_BG" -f "$SOURCE_CODE" -f "$FAWESOME" -n "noshadow"
	fi
}

function changeVolume() {
	case $1 in
		VolumeP*)
	        update_wallpaper
			(echo -e "%{c}\uf028 $(Volume)"; sleep .4) | lemonbar -d -g "$(geometry small top_right)" -F "$COLOR_POPUP_FG" -B "$COLOR_POPUP_BG" -f "$SOURCE_CODE" -f "$FAWESOME" -n "noshadow"
			;;
		VolumeM*)
	        update_wallpaper
			(echo -e "%{c}\uf027 $(Volume)"; sleep .4) | lemonbar -d -g "$(geometry small top_right)" -F "$COLOR_POPUP_FG" -B "$COLOR_POPUP_BG" -f "$SOURCE_CODE" -f "$FAWESOME" -n "noshadow"
			;;
	esac
}

function getBacklightLevel() {
	case $1 in
		lightPlus*)
			light=$(xbacklight)
			#light=$(ceiling $light)
			light=$( printf "%.0f" $light )
			(echo -e "%{c}\uf185 $light"; sleep .6) | lemonbar -d -g "$(geometry small top_right)" -F "$COLOR_POPUP_FG" -B "$COLOR_POPUP_BG" -f "$SOURCE_CODE" -f "$FAWESOME" -n "noshadow"
			;;
		lightMinus*)
			light=$(xbacklight)
			light=$( printf "%.0f" $light )
			(echo -e "%{c}\uf185 ${light}"; sleep .6) | lemonbar -d -g "$(geometry small top_right)" -F "$COLOR_POPUP_FG" -B "$COLOR_POPUP_BG" -f "$SOURCE_CODE" -f "$FAWESOME" -n "noshadow"
			;;
	esac
}

function workspace() {
	name=$(bspc query -T -m -d | jshon -e name | tr -d '"')
	case $name in
		1)
			echo "\uf120"
			;;
		2)
			#echo "\uf292\uf12a"
			echo "\uf121"
			;;
		3)
			echo "\uf268"
			;;
		4)
			echo "\uf144"
			;;
		5)
			echo "\uf125"
			;;
		6)
			echo "\uf124"
			;;
		7)
			echo "\uf127"
			;;
		8)
			echo "\uf0ce"
			;;
	esac
}

function color_battery() {
	bat=$(getBattery)
	color=$(arithmetic_bspwm.py c_battery $((bat)))
	case $color in
		URGENT*)
			echo "$COLOR_POPUP_URGENT_FG"
			;;
		NORMAL*)
			echo "$COLOR_POPUP_FG"
			;;
	esac
}

#color_battery
