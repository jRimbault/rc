#!/bin/bash

bspc rule --add mpv state=floating desktop='^4' follow=on
bspc rule --add "Gimp-2.8" desktop='^5' state=floating follow=on
bspc rule --add "PyCharm Community Edition Privacy Policy Agreement" desktop='^5' state=floating follow=on
bspc rule --add Pycharm desktop='^2' state=floating follow=on
bspc rule --add chromium desktop='^3' follow=on focus=true
bspc rule --add Chromium desktop='^3' follow=on focus=true
bspc rule --add "google-chrome" desktop='^3' follow=on focus=true
bspc rule --add "Google-chrome" desktop='^3' follow=on focus=true
bspc rule --add Sublime_text desktop='^2' follow=on focus=true #state=tiled
bspc rule --add sublime_text desktop='^2' follow=on focus=true #state=tiled
bspc rule --add code desktop='^6' follow=on focus=true fullscreen=true
bspc rule --add Code desktop='^6' follow=on focus=true fullscreen=true
bspc rule --add Screenkey manage=off
bspc rule --add URxvt:floating state=floating
bspc rule --add URxvt:scratchpad state=floating sticky=true layer=above focus=true
bspc rule --add GLUT state=floating
bspc rule --add vmware desktop='^5' follow=on focus=true
bspc rule --add Vmware desktop='^5' follow=on focus=true
bspc rule --add Keybase state=floating
