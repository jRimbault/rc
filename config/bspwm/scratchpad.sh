#!/usr/bin/env bash

if ! xdotool search --onlyvisible --classname 'scratchpad' windowunmap; then
	if ! xdotool search --classname 'scratchpad' windowmap; then
		urxvtc -title 'scratchpad' -name 'scratchpad'
		bspc window --swap biggest
	fi
fi
