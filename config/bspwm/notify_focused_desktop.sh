#!/bin/bash
empty_icon="%{O1}\uf096"
filled_icon="\uf0c8"
focused_icon="%{F$notify_icon_fg}$filled_icon%{F$notify_color_fg}"

notification=""
focused=$(bspc query -D -d)
for row in {1..2}; do
	for col in {1..3}; do
		cell=$empty_icon
		if [[ $col-$row == $focused ]]; then
			cell=$focused_icon
		elif [[ -n $(bspc query -N -d $col-$row) ]]; then
			cell=$filled_icon
		fi
		cell="%{A:bspc desktop -f $col-$row && $0:}$cell%{A}"
		if [[ $col -eq 1 ]]; then
			notification=$notification$cell
		else
			notification=$notification' '$cell
		fi
  
	done
	notification=$notification";"
done
notification=${notification::-1}
notify-no-icon "$notification"