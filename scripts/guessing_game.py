#!/usr/bin/env python3

import argparse
import json
import os
import urllib.request
from typing import Iterator


subreddits = {"1": "nottheonion", "2": "TheOnion"}

NT = os.name == "nt"


class Color:
    GREEN = "\033[92m"
    RED = "\033[91m"
    RESET = "\033[0m"
    BOLD = "\033[1m"

    @staticmethod
    def _reset(color, message):
        return message if NT else f"{color}{message}{Color.RESET}"

    @staticmethod
    def bold(message):
        return Color._reset(Color.BOLD, message)

    @staticmethod
    def fail(message):
        return Color._reset(Color.RED, message)

    @staticmethod
    def ok(message):
        return Color._reset(Color.GREEN, message)


class Post:
    def __init__(self, data: dict):
        self.data = data

    @property
    def title(self) -> str:
        return self.data["data"]["title"].title()

    @property
    def subreddit(self) -> str:
        return self.data["data"]["subreddit"]

    @property
    def domain(self) -> str:
        return self.data["data"]["domain"]


def question(subreddits: dict) -> str:
    q = ["From which subreddit did this come from ?"]
    q.extend([f"  {key} - r/{sub}" for key, sub in subreddits.items()])
    q.extend(["  q - Quit", ""])
    return "\n".join(q)


def get_posts(subreddits: dict) -> Iterator[Post]:
    def get_data(url: str) -> dict:
        r = urllib.request.urlopen(url, timeout=10)
        return json.loads(r.read())

    reddits = "+".join(s for s in subreddits.values())
    data = get_data(f"https://api.reddit.com/r/{reddits}/")
    return map(Post, data["data"]["children"])


def ask(question: str) -> str:
    reply = input(question)
    while reply not in subreddits and reply != "q":
        reply = input()
    return reply


def game(subreddits: dict) -> (int, int):
    total = 0
    score = 0
    for post in get_posts(subreddits):
        print(f'>> "{Color.bold(post.title)}"')
        reply = ask(question(subreddits))
        if reply == "q":
            break
        if subreddits[reply] == post.subreddit:
            print(f"{Color.ok('✓')} Correct", end=", ")
            score += 1
        else:
            print(f"{Color.fail('✗')} Incorrect", end=", ")
        print(f"this was from {post.domain}")
        total += 1
    return score, total


def main(subreddits: dict):
    score, total = game(subreddits)
    print(f"Final score : {score}/{total}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-sr",
        "--subreddits",
        dest="subreddits",
        nargs="+",
        help=(
            "The defaults are r/TheOnion and r/nottheonion. "
            "You can change those by passing a list."
        ),
    )
    args = parser.parse_args()
    if args.subreddits:
        subreddits = {str(i + 1): s for i, s in enumerate(args.subreddits)}

    try:
        main(subreddits)
    except KeyboardInterrupt:
        print()
    except Exception as e:
        print(f"{type(e).__name__}: {e}")
        exit(1)
