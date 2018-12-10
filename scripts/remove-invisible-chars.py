#!/usr/bin/env python3

import fileinput
import sys


def stripped(text):
    """Remove invisible characters

    Remove all characters not between the ascii 32 and 127
    and not an ascii 10 (line feed)
    """

    def whitelist(c: int) -> bool:
        if 31 < c < 127:
            return True
        if c == 10:
            return True
        return False

    return "".join(c for c in text if whitelist(ord(c)))


def main(file):
    print(stripped("".join(file)))


if __name__ == "__main__":
    main(fileinput.input())
