#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @author: jRimbault
# @date:   2017-08-27
# @last modified by:   jRimbault
# @last modified time: 2017-09-20

import subprocess
from Geometry import Geometry


class Popup:
    def __init__(self, msg='Nothing', time=2.0):
        """Customizable lemonbar popups"""
        # constructs the command
        # first echo, then sleep, then lemonbar
        self.lemonbar = (
            ')',
            '|',
            'lemonbar',
            '-d'
        )
        self.message(msg)
        self.duration(time)

    def message(self, msg='Nothing'):
        """What to say in the popup"""
        self.echo = (
            '(',
            'echo',
            '-e',
            '"%{c}' + str(msg) + '"',
        )

    def duration(self, time=2.0):
        """For how long to display the popup, in seconds"""
        self.sleep = (
            ';',
            'sleep',
            str(time)
        )

    def geometry(self, size, position, margins):
        definitionGeo = Geometry(size, position, margins)
        self.lemonbar += (
            '-g',
            str(definitionGeo)
        )

    def colors(
        self,
        background='"#202020"',
        foreground='"#dddddd"'
    ):
        """Colors of the popup
        Colors should be #RRGGBB enclosed in double quotes
        """
        self.lemonbar += (
            '-B',
            background,
            '-F',
            foreground,
        )

    def fonts(
        self,
        letterfont='"Source Code Pro for Powerline-12"',
        iconfont='"FontAwesome-16"'
    ):
        self.lemonbar += (
            '-f',
            letterfont,
            '-f',
            iconfont
        )

    def name(self, n='"lemonbar"'):
        """Name reported to the window manager
        Enclosed in double quotes"""
        self.lemonbar += (
            '-n',
            n
        )

    def make_command(self):
        command = self.echo + self.sleep + self.lemonbar
        return ' '.join(command)

    def show(self):
        subprocess.run(
            self.make_command(),
            stdin=subprocess.PIPE,
            shell=True
        )
