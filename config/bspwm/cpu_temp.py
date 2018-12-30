#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @author: jRimbault
# @date:   2017-09-01
# @last modified by:   jRimbault
# @last modified time: 2017-09-20

import argparse
import subprocess
import re
import Lemonbar


def get_cpu_temp():
    ret = subprocess.run(
        [
            'sensors',
            'coretemp-isa-0000'
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True
    )
    for line in ret.stdout.splitlines():
        if re.search('Core 0', line):
            temp = line[16] + line[17]
            return int(temp.replace('\n', ''))


def color(temp):
    if temp > 45:
        return '"#FB5457"'
    return '"#dddddd"'


def main(args):
    temp = get_cpu_temp()
    cpu_temp = Lemonbar.Popup('CPU: ' + str(temp) + '°C', 2)
    cpu_temp.colors('"#202020"', color(temp))
    cpu_temp.fonts()
    cpu_temp.name()
    cpu_temp.geometry(
        (150, 60),
        'top_right',
        (60, 60)
    )
    cpu_temp.show()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='''Get CPU temp and display with lemonbar''',
        formatter_class=argparse.RawTextHelpFormatter
    )

    args = parser.parse_args()
    main(args)
