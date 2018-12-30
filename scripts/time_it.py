#!/usr/bin/env python3

import subprocess
import sys
import timeit


def main():
    number = 10
    timer = timeit.Timer(stmt=run(), globals=globals())
    seconds = timer.timeit(number=number)
    print(seconds / number)


def run():
    return """
subprocess.run(sys.argv[1:])
"""


if __name__ == "__main__":
    main()
