#!/bin/bash

current_desktop=$(bspc query -T -m -d | jshon -e name | tr -d '"')
current_padding=$(bspc query -T -m -d | jshon -e padding | jshon -e right)

case $current_desktop in
	1)
		desktop_1.sh
		if [[ $current_padding -eq 131 ]]; then
			vertical_layout.sh $current_desktop
		fi
		;;
	2)
		desktop_2.sh
		if [[ $current_padding -eq 47 ]]; then
			vertical_layout.sh $current_desktop
		fi
		;;
	3)
		desktop_3.sh
		if [[ $current_padding -eq 0 ]]; then
			vertical_layout.sh $current_desktop
		fi
		;;
	4)
		desktop_4.sh
		if [[ $current_padding -eq 19 ]]; then
			vertical_layout.sh $current_desktop
		fi
		;;
	5)
		desktop_5.sh
		if [[ $current_padding -eq 19 ]]; then
			vertical_layout.sh $current_desktop
		fi
		;;
	6)
		desktop_6.sh
		if [[ $current_padding -eq 19 ]]; then
			vertical_layout.sh $current_desktop
		fi
		;;
	7)
		common_padding.sh $current_desktop
		if [[ $current_padding -eq 27 ]]; then
			vertical_layout.sh $current_desktop
		fi
		;;
	8)
		common_padding.sh $current_desktop
		if [[ $current_padding -eq 27 ]]; then
			vertical_layout.sh $current_desktop
		fi
		;;
esac
