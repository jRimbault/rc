#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @author: jRimbault
# @date:   2017-09-20
# @last modified by:   jRimbault
# @last modified time: 2017-09-20

import os
os.environ['NO_AT_BRIDGE'] = '1'
import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk


class Geometry:
    resolution = (
        Gtk.Window().get_screen().get_width(),
        Gtk.Window().get_screen().get_height()
    )

    def __init__(self, d=(100, 60), p='center', m=(60, 60)):
        """
        What size has the popup
          (x: width, y: height)
        What position has the popup
          top_left|top_right|center|bottom_left|bottom_right
        What margins it should use (from the screen limit):
          (x: lateral, y: medial)
        """
        self.mar = m
        self.dim = d
        self.pos = p

    def __str__(self):
        return str(self.dim[0]) + 'x' + str(self.dim[1]) + self.position(self.pos)

    def position(self, p='center'):
        """Where is the popup
        top_left|top_right|bottom_left|bottom_right|center
        Depends on size() and margins()
        """
        func = {
            'center': self.center,
            'top_left': self.top_left,
            'top_right': self.top_right,
            'bottom_left': self.bottom_left,
            'bottom_right': self.bottom_right
        }
        return func[p]()

    def padding_horizontal(self, v):
        """calculates the horizontal padding"""
        return str(self.resolution[0] - (v + self.mar[0]))

    def padding_vertical(self, v):
        """calculates the vertical padding"""
        return str(self.resolution[1] - (v + self.mar[1]))

    def center(self):
        x = int(self.resolution[0] / 2 - self.dim[0] / 2)
        y = int(self.resolution[1] / 2 - self.dim[1] / 2)
        return '+' + str(x) + '+' + str(y)

    # positions of the popup
    def top_left(self):
        return '+' + str(self.mar[0]) + '+' + str(self.mar[1])

    def top_right(self):
        return '+' + self.padding_horizontal(self.dim[0]) + '+' + str(self.mar[1])

    def bottom_left(self):
        return '+' + str(self.mar[0]) + '+' + self.padding_vertical(self.dim[1])

    def bottom_right(self):
        return '+' + self.padding_horizontal(self.dim[0]) + '+' + self.padding_vertical(self.dim[1])
