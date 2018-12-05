#!/usr/bin/env python3

import collections
import fileinput


def most_common_chars(file):
    counter = collections.Counter(''.join(file))
    return counter.most_common()


def main(file):
    to_string = lambda char, count: f"{repr(char).rjust(4)} : {count}"
    display = (to_string(char, count)
                for char, count
                in reversed(most_common_chars(file)))
    print('\n'.join(display))


if __name__ == '__main__':
    main(fileinput.input())
