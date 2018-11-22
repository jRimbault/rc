#!/usr/bin/env python3

import sys


def stripped(text):
    """Remove invisible characters
    In fact remove all characters not between the ascii 32 and 127
    and not an ascii 10 (line feed)
    """
    whitelist = [10]
    whitelist.extend(range(32, 127))
    return ''.join(c for c in text if ord(c) in whitelist)


def main(file):
    with open(file) as bad_file:
        print(stripped(bad_file.read()))


if __name__ == '__main__':
    if len(sys.argv) < 2:
        exit(1)
    main(sys.argv[1])
