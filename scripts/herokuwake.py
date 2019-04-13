#!/usr/bin/env python3

import argparse
import sys
import time
from urllib.parse import urlparse
from urllib.error import HTTPError
from urllib.request import Request, urlopen


def main(args):
    while True:
        for url in map(tourl, args.urls):
            try:
                wakeup(url.geturl())
                print(url.netloc, "is awake")
            except HTTPError as error:
                print(url.netloc, error, "but might be awake")
        time.sleep(20 * 60)


def wakeup(url):
    return urlopen(Request(url, headers={"User-Agent": "Wake up bot"})).read(1)


def tourl(address: str):
    return urlparse("//" + address, scheme="https")


def parse_args(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument("urls", nargs="+")
    return parser.parse_args(argv)


if __name__ == "__main__":
    try:
        main(parse_args(sys.argv[1:]))
    except KeyboardInterrupt:
        print()
