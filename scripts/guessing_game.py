#!/usr/bin/env python3

from typing import List
import requests


subreddit = {
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


def question(subreddit: dict) -> str:
    q = ['From which subreddit did this come from ?']
    for key, sub in subreddit.items():
        if sub == None:
            q.append('  q - Quit')
            continue
        q.append(f'  {key} - r/{sub}')
    q.append('')
    return '\n'.join(q)


def get_posts(subreddit: dict) -> List[Post]:
    def get_data(url: str) -> dict:
        r = requests.get(url)
        return r.json()
    filtered_subreddit = [v for v in subreddit.values() if v is not None]
    reddits = '+'.join(filtered_subreddit)
    json = get_data(f'https://api.reddit.com/r/{reddits}/')
    try:
        return map(Post, json['data']['children'])
    except KeyError:
        print(json['message'])
        exit(1)


def main(subreddit: dict):
    def ask(question: str) -> str:
        reply = input(question)
        while reply not in subreddit:
            reply = input()
        return reply

    total = 0
    score = 0
    subreddit['q'] = None
    for post in get_posts(subreddit):
        print(f'>> "{post.title()}"')
        reply = ask(question(subreddit))
        if reply == 'q':
            break
        if subreddit[reply] == post.subreddit():
            print('Correct')
            score += 1
        else:
            print('Incorrect')
        total += 1

    print(f'Final score : {score}/{total}')



if __name__ == '__main__':
    main(subreddit)
