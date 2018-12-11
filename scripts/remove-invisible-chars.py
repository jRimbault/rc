#!/usr/bin/env python3
# _ = list(map(print, map(chr, range(33, 127))))

import fileinput


def stripped(text):
    """Remove invisible characters

    Remove all characters not between the ascii 32 and 127
    and not an ascii 10 (line feed)
    """

    def whitelist(c: int) -> bool:
        if 32 < c < 127 or c == 10:
            return True
        return False

    return "".join(map(chr, filter(whitelist, map(ord, text))))


def main(file):
    print(stripped("".join(file)))


if __name__ == "__main__":
    main(fileinput.input())
