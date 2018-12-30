#!/bin/bash

# common layout
common_layout() {
	bspc config -d $1 top_padding              0
	bspc config -d $1 bottom_padding           0
	bspc config -d $1 left_padding             27
	bspc config -d $1 right_padding            27
}

common_layout $1