#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @author: jRimbault
# @date:   2017-08-27
# @last modified by:   jRimbault
# @last modified time: 2017-09-20

import argparse
import Lemonbar


def read_battery_capacity():
    with open('/sys/class/power_supply/BAT0/capacity', 'r') as file:
        content = file.read()
    return int(content.replace('\n', ''))


def read_battery_status():
    with open('/sys/class/power_supply/BAT0/status', 'r') as file:
        content = file.read()
    return content.replace('\n', '')


def icon():
    status = read_battery_status()
    capacity = read_battery_capacity()
    icon_ = '\uf244 '

    if capacity > 15:
        icon_ = '\uf243 '
    if capacity > 45:
        icon_ = '\uf242 '
    if capacity > 75:
        icon_ = '\uf241 '
    if capacity > 90:
        icon_ = '\uf240 '

    if status == 'Charging':
        icon_ = '\uf1e6 '
    if status == 'Discharging' and capacity >= 99:
        icon_ = '\uf1e6 '

    return icon_


def color():
    capacity = read_battery_capacity()
    color_ = '"#FB5457"'

    if capacity > 20:
        color_ = '"#aaaaaa"'
    if capacity > 80:
        color_ = '"#5BC236"'
    if capacity == 100:
        color_ = '"#00D7FF"'

    return color_


def main(args):
    battery = Lemonbar.Popup(icon() + str(read_battery_capacity()) + '%', 2)
    battery.name()
    battery.colors('"#202020"', color())
    battery.fonts()
    battery.geometry(
        (100, 60),
        'top_right',
        (60, 60)
    )
    if args.quiet:
        print(str(read_battery_capacity()) + '%')
    if not args.quiet and not args.verbose:
        battery.show()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='''Get battery level, display with lemonbar'''
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
    argso = parser.parse_args()
    main(argso)
