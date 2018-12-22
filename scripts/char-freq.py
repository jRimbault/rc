#!/usr/bin/env python3

import collections
import fileinput


def rmost_common(iterable):
    counter = collections.Counter(iterable)
    return reversed(counter.most_common())


def display_counter(counter):
    print("\n".join(f"{repr(el).rjust(4)} : {count}" for el, count in counter))


def main(text):
    display_counter(rmost_common(text))


if __name__ == "__main__":
    main("".join(fileinput.input()))
