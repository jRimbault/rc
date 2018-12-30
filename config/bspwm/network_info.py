#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @author: jRimbault
# @date:   2017-09-03 14:16:54
# @last modified by:   jRimbault
# @last modified time: 2017-09-10

import argparse
import re
import subprocess


def get_ssid():
    ret = subprocess.run(
        [
            'nmcli',
            '-t',
            '-f',
            'active,ssid',
            'dev',
            'wifi'
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True
    )
    ssid = ''
    for line in ret.stdout.splitlines():
        if re.search('yes', line):
            for i in range(len(line) - 4):
                ssid += line[i + 4]

    return ssid.replace('\n', '')


def get_ip_wan():
    ret = subprocess.run(
        [
            'externalip.sh',
            'dns'
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True
    )
    return ret.stdout.replace('\n', '')


def get_ip_lan():
    ret = subprocess.run(
        [
            'externalip.sh',
            'dns'
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True
    )
    return ret.stdout.replace('\n', '')


def main(args):
    print(get_ip_lan())


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='''
            Get network infos and display with lemonbar''',
        formatter_class=argparse.RawTextHelpFormatter
    )

    parser.add_argument(
        'info',
        help='[ ssid | ipwan | iplan ]',
        type=str
    )

    args = parser.parse_args()
    main(args)
