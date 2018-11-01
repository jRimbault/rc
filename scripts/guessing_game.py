#!/usr/bin/env python3

from typing import List
import argparse
import requests


subreddits = {
    '1': 'nottheonion',
    '2': 'TheOnion',
}


class Post:
    def __init__(self, data: dict):
        self.data = data
    def title(self) -> str:
        return self.data['data']['title']
    def subreddit(self) -> str:
        return self.data['data']['subreddit']


def question(subreddits: dict) -> str:
    q = ['From which subreddit did this come from ?']
    for key, sub in subreddits.items():
        if sub == None:
            continue
        q.append(f'  {key} - r/{sub}')
    q.append('  q - Quit')
    q.append('')
    return '\n'.join(q)


def get_posts(subreddits: dict) -> List[Post]:
    def get_data(url: str) -> dict:
        r = requests.get(url)
        return r.json()
    filtered_subreddits = [v for v in subreddits.values() if v is not None]
    reddits = '+'.join(filtered_subreddits)
    json = get_data(f'https://api.reddit.com/r/{reddits}/')
    try:
        return map(Post, json['data']['children'])
    except KeyError:
        print(json['message'], json['error'])
        exit(1)


def main(subreddits: dict):
    def ask(question: str) -> str:
        reply = input(question)
        while reply not in subreddits:
            reply = input()
        return reply

    total = 0
    score = 0
    subreddits['q'] = None
    for post in get_posts(subreddits):
        print(f'>> "{post.title()}"')
        reply = ask(question(subreddits))
        if reply == 'q':
            break
        if subreddits[reply] == post.subreddit():
            print('Correct')
            score += 1
        else:
            print('Incorrect')
        total += 1

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
    main(subreddits)
