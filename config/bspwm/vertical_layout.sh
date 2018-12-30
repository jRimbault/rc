#!/bin/bash

# vertical layout
vertical_layout() {
	bspc config -d $1 top_padding              36
	bspc config -d $1 bottom_padding           36
	bspc config -d $1 left_padding            515
	bspc config -d $1 right_padding           515
	bspc config -d $1 window_gap               24
}

vertical_layout $1