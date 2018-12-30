#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @author: jRimbault
# @date:   2017-08-28
# @last modified by:   jRimbault
# @last modified time: 2017-09-20


import argparse
import subprocess
import Lemonbar
from arg_custom_types import interval
from arg_custom_types import less_than_100


def get_current_level():
    ret = subprocess.run(
        ['xbacklight', '-get'],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True
    )
    f = float(ret.stdout.replace('\n', ''))
    return int(round(f, 0))


def set_light_level(x):
    subprocess.run(
        ['xbacklight', '-set', str(x)],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True
    )


def increment_light_level(x):
    x = get_current_level() + x
    set_light_level(x)


def main(args):
    if args.verbose:
        print('Current level:', get_current_level())

    if args.increment:
        if args.verbose:
            print('Increment by:', args.increment)
        increment_light_level(args.increment)

    if args.set:
        if args.verbose:
            print('Set to:', args.set)
        set_light_level(args.set)

    if args.verbose:
        print('New level set to:', get_current_level())

    if not args.quiet and not args.verbose:
        lighting = Lemonbar.Popup('\uf185 ' + str(get_current_level()), 2)
        lighting.colors('"#202020"', '"#dddddd"')
        lighting.fonts()
        lighting.name()
        lighting.geometry(
            (100, 60),
            'top_right',
            (60, 60)
        )
        lighting.show()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='''
Wrapper around xbacklight
Adjusts the screen backlighting
xbacklight was not precise enough to my taste''',
        formatter_class=argparse.RawTextHelpFormatter
    )

    group_action = parser.add_mutually_exclusive_group()
    group_action.add_argument(
        '-i',
        '--increment',
        help='increase or decrease backlighting by `x`',
        type=interval,
    )
    group_action.add_argument(
        '-s',
        '--set',
        help='set backlighting to `x`',
        type=less_than_100,
    )

    group_verbose = parser.add_mutually_exclusive_group()
    group_verbose.add_argument(
        '-v',
        '--verbose',
        help='display verbose steps on stdout',
        action='store_true'
    )
    group_verbose.add_argument(
        '-q',
        '--quiet',
        help="don't display a popup",
        action='store_true'
    )
    args = parser.parse_args()
    main(args)
