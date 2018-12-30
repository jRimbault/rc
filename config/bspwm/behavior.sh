#!/bin/bash

# behavior
bspc config split_ratio            0.5
bspc config borderless_monocle     true
bspc config gapless_monocle        true
bspc config click_to_focus         true
#bspc config focus_follows_pointer  true

bspc config initial_polarity second_child

bspc config pointer_modifier     mod4
bspc config pointer_action1      move

