#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @author: jRimbault
# @date:   2017-08-30
# @last modified by:   jRimbault
# @last modified time: 2017-09-20

import argparse
import time
import Lemonbar


def main(args):
    clock = Lemonbar.Popup('\uf017 ' + time.strftime('%a %d %B %H:%M'), 3)
    clock.colors('"#202020"', '"#dddddd"')
    clock.fonts()
    clock.name()
    clock.geometry(
        (280, 60),
        'top_right',
        (60, 60)
    )
    clock.show()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='''Display clock with lemonbar''',
        formatter_class=argparse.RawTextHelpFormatter
    )
    args = parser.parse_args()
    main(args)
