#!/usr/bin/env python3

import argparse
import os
import subprocess
import sys
from contextlib import contextmanager


def main(args):
    with out_file(args.output) as out:
        print_csv(lambda s: print(s, file=out))


def print_csv(printer: callable):
    printer("files;insertions;deletions;author;branch")
    for stats in collect_stats(git_authors()):
        printer(stats)


def check_output(command):
    return subprocess.check_output(command).decode("utf-8", "ignore")


def collect_stats(authors):
    reporter = status(len(authors))
    for i, author in enumerate(authors):
        try:
            yield check_output(("git-insertions", author)).strip()
        except subprocess.CalledProcessError:
            continue
        reporter(i)
    print("\nDone.", file=sys.stderr)


def status(total):
    def report(i):
        print(f"{i+1:>{formatter}}/{total}", file=sys.stderr, end="\r")

    formatter = len(str(total))
    return report


def git_authors():
    print("Fetching list of committers...", file=sys.stderr)
    return check_output(("git-authors")).splitlines()


@contextmanager
def out_file(file):
    try:
        out = open(file, "w", buffering=1)
        yield out
    except TypeError:
        yield sys.stdout
    finally:
        if "out" in locals():
            out.close()


def parse_args(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", "-o", help="Output file")
    return parser.parse_args(argv)


if __name__ == "__main__":
    try:
        main(parse_args(sys.argv[1:]))
    except KeyboardInterrupt:
        print()
