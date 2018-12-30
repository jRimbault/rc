#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @author: jRimbault
# @date:   2017-08-30
# @last modified by:   jRimbault
# @last modified time: 2017-09-20

import argparse
import subprocess
import Lemonbar
from arg_custom_types import interval
from arg_custom_types import less_than_100


def toggle_mute_sound():
    subprocess.run(
        [
            'pamixer',
            '--toggle-mute'
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True
    )


def get_volume():
    ret = subprocess.run(
        [
            'pamixer',
            '--get-volume'
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True
    )
    f = float(ret.stdout.replace('\n', ''))
    return int(round(f, 0))


def is_muted():
    ret = subprocess.run(
        [
            'pamixer',
            '--get-mute'
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True
    )
    if ret.stdout.replace('\n', '') == 'true':
        return True
    return False


def set_volume(x):
    subprocess.run(
        [
            'pamixer',
            '--set-volume',
            str(x)
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True
    )


def increment_volume(x):
    x = get_volume() + x
    set_volume(x)


def main(args):
    to_print = '\uf028 '

    if args.increment:
        increment_volume(args.increment)
        if args.increment < 0:
            to_print = '\uf027 '

    if args.set:
        set_volume(args.set)

    if args.mute:
        toggle_mute_sound()
        if is_muted():
            to_print = '\uf026 '
    else:
        to_print += str(get_volume())

    sound_state = Lemonbar.Popup(to_print, 0.4)
    sound_state.colors()
    sound_state.geometry(
        (100, 60),
        'top_right',
        (60, 60)
    )
    sound_state.fonts()
    sound_state.name()
    sound_state.show()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='''Control volume and display with lemonbar''',
        formatter_class=argparse.RawTextHelpFormatter
    )

    group_action = parser.add_mutually_exclusive_group()
    group_action.add_argument(
        '-i',
        '--increment',
        help='increase or decrease valume by `x`',
        type=interval,
    )
    group_action.add_argument(
        '-s',
        '--set',
        help='set valume to `x`',
        type=less_than_100,
    )
    group_action.add_argument(
        '-m',
        '--mute',
        help='mute sound',
        action='store_true'
    )

    args = parser.parse_args()
    main(args)
