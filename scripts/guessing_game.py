#!/usr/bin/env python3

import os
from typing import List
import argparse
import urllib.request
import json


subreddits = {
    '1': 'nottheonion',
    '2': 'TheOnion',
}

NT = os.name == 'nt'


class Color:
    OKGREEN = '\033[92m'
    FAIL = '\033[91m'
    RESET = '\033[0m'
    @staticmethod
    def _reset(color, message):
        if NT:
            return message
        return f'{color}{message}{Color.RESET}'
    @staticmethod
    def fail(message):
        return Color._reset(Color.FAIL, message)
    @staticmethod
    def ok(message):
        return Color._reset(Color.OKGREEN, message)


class Post:
    def __init__(self, data: dict):
        self.data = data
    @property
    def title(self) -> str:
        return self.data['data']['title'].title()
    @property
    def subreddit(self) -> str:
        return self.data['data']['subreddit']
    @property
    def domain(self) -> str:
        return self.data['data']['domain']


def question(subreddits: dict) -> str:
    q = ['From which subreddit did this come from ?']
    q.extend([f'  {key} - r/{sub}' for key, sub in subreddits.items()])
    q.extend(['  q - Quit', ''])
    return '\n'.join(q)


def get_posts(subreddits: dict) -> List[Post]:
    def get_data(url: str) -> dict:
        r = urllib.request.urlopen(url, timeout=10)
        return json.loads(r.read())
    reddits = '+'.join(s for s in subreddits.values())
    data = get_data(f'https://api.reddit.com/r/{reddits}/')
    try:
        return map(Post, data['data']['children'])
    except KeyError:
        print(data['message'], data['error'])
        exit(1)


def ask(question: str) -> str:
    reply = input(question)
    while reply not in subreddits and reply != 'q':
        reply = input()
    return reply


def game(subreddits: dict) -> (int, int):
    total = 0
    score = 0
    for post in get_posts(subreddits):
        print(f'>> "{post.title}"')
        reply = ask(question(subreddits))
        if reply == 'q':
            break
        if subreddits[reply] == post.subreddit:
            print(Color.ok('✓ Correct'))
            score += 1
        else:
            print(Color.fail('✗ Incorrect'))
        print(f'This was from {post.domain}')
        total += 1
    return score, total


def main(subreddits: dict):
    score, total = game(subreddits)
    print(f'Final score : {score}/{total}')


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-sr',
        '--subreddits',
        dest='subreddits',
        nargs='+',
        help=(
            'The defaults are r/TheOnion and r/nottheonion. '
            'You can change those by passing a list.'
        )
    )
    args = parser.parse_args()
    if args.subreddits:
        sr = args.subreddits
        subreddits = {str(i+1): s for i, s in enumerate(sr)}

    try:
        main(subreddits)
    except KeyboardInterrupt:
        print()
    except Exception as e:
        print(e)
        exit(1)
