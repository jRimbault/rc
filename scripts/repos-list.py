#!/usr/bin/env python3

import argparse
import json
import sys
from urllib.request import urlopen


def main(args):
    print("\n".join(user_repos(args.user)))


def user_repos(user):
    repos = f"https://api.github.com/users/{user}/repos"
    return (repo["name"] for repo in get(repos))


def get(url):
    r = urlopen(url)
    return json.loads(r.read())


if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("user")
    try:
        sys.exit(main(p.parse_args()))
    except KeyboardInterrupt:
        print()
