#!/usr/bin/env bash


DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then
	DIR="$PWD"
fi
source "$DIR/dep/panel_colors"
source "$DIR/dep/popup_functions.sh"

FIXED_FONT="-*-fixed-*-*-*-*-14-*-*-*-*-*-*-*"
SOURCE_CODE="Source Code Pro for Powerline-12"
#SOURCE_CODE="Fira Mono for Powerline-12"
SANS_FONT="-*-tamsyn-medium-r-normal-*-12-*-*-*-*-*-*-1"
PANEL_FONT_2="-wuncon-siji-medium-r-normal--10-100-75-75-c-80-iso10646-1"
FAWESOME="FontAwesome-16"

wifi_status=$(nmcli n)
wifi=false
if [[ $wifi_status = "enabled" ]];then
	wifi=true
fi


case $1 in
	Muted)
        update_wallpaper
		getIfMuted
		;;
	Volume*)
		changeVolume $1
		;;
	light*)
		getBacklightLevel $1
		;;
	allBattery)
		(echo -e "%{c}$(acpi --battery | awk '{$1=$1};1')"; sleep 5) |
		DISPLAY=:0 lemonbar -d -g "$(geometry xx-large top_right)" -F "$COLOR_POPUP_FG" -B "$COLOR_POPUP_BG" -f "$SOURCE_CODE" -f "$FAWESOME" -n "lemonbar"
		;;
	Clock)
		(echo -e "%{c}\uf017 $(Clock)"; sleep 3) |
		lemonbar -d -g "$(geometry x-large top_right)" -F "$COLOR_POPUP_FG" -B "$COLOR_POPUP_BG" -f "$SOURCE_CODE" -f "$FAWESOME" -n "lemonbar"
		;;
	cpu_temp)
		temp=$(sensors coretemp-isa-0000 | grep "Core 0" | cut -c17-23)
		(echo -e "%{c}CPU: $temp"; sleep 5) |
		lemonbar -d -g "$(geometry medium top_right)" -F "$COLOR_URGENT2_FG" -B "$COLOR_POPUP_BG" -f "$SOURCE_CODE" -f "$FAWESOME" -n "lemonbar"
		;;
	myip)
		myip=$(bash /home/erelde/.bin/externalip.sh dns)
		if [[ $wifi = "false" ]]; then
			popup.sh switch_wifi
			exit 1
		fi
		(echo -e "%{c}\uf1eb $myip"; sleep 5) |
		lemonbar -d -g "$(geometry large top_left)" -F "$COLOR_POPUP_FG" -B "$COLOR_POPUP_BG" -f "$SOURCE_CODE" -f "$FAWESOME" -n "lemonbar"
		;;
	SSID)
		network="$(nmcli -t -f active,ssid dev wifi | grep -E '^yes' | cut -d':' -f2)"
		if [[ $wifi = "false" ]]; then
			popup.sh switch_wifi
			exit 1
		fi
		(echo -e "%{c}\uf1eb $network"; sleep 5) |
		lemonbar -d -g "$(geometry large bot_right)" -F "$COLOR_POPUP_FG" -B "$COLOR_POPUP_BG" -f "$SOURCE_CODE" -f "$FAWESOME" -n "lemonbar"
		;;
	LAN)
		#network="$(ip address show wlan0 | grep 'inet ' | cut -d ' ' -f6 | sed -e 's/\/24//g' )"
		network=$(ip address show wlan0 | grep "inet\ " | cut -d " " -f6 | sed -r "s/\/[0-9]{1,2}//g")
		if [[ $wifi = "false" ]]; then
			popup.sh switch_wifi
			exit 1
		fi
		(echo -e "%{c}\uf1eb $network"; sleep 5) |
		lemonbar -d -g "$(geometry large bot_left)" -F "$COLOR_POPUP_FG" -B "$COLOR_POPUP_BG" -f "$SOURCE_CODE" -f "$FAWESOME" -n "lemonbar"
		;;
	switch_wifi)
		(echo -e "%{c}\uf1eb Wifi $wifi_status."; sleep 5) |
		lemonbar -d -g "$(geometry large bot_left)" -F "$COLOR_URGENT_FG" -B "$COLOR_POPUP_BG" -f "$SOURCE_CODE" -f "$FAWESOME" -n "lemonbar"
		;;
	sshfs)
		sshfs="$(bash /home/erelde/.bin/sshfs.home.sh)"
		(echo -e "%{c}\ue0a2 $sshfs"; sleep 2) |
		lemonbar -d -g "$(geometry large top_right)" -F "$COLOR_POPUP_FG" -B "$COLOR_POPUP_BG" -f "$SOURCE_CODE" -f "$FAWESOME" -n "lemonbar"
		;;
	test)
		(echo -e "%{c}\uf26b"; sleep 1) |
		lemonbar -d -g "$(center_popup 160 160)" -F "$COLOR_POPUP_FG" -B "$COLOR_POPUP_BG" -f "$FAWESOME" -n "lemonbar"
		;;
	Desktop)
		(echo -e "%{c}$(workspace)"; sleep .7) |
		lemonbar -d -g "$(center_popup 80 80)" -F "$COLOR_WHITE" -B "$COLOR_POPUP_BG" -f "$SOURCE_CODE" -f "$FAWESOME" -n "lemonbar"
		;;
	*)
		echo CLI
		;;
esac
