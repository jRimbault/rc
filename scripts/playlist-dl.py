#!/usr/bin/env python3

import os
import sys
import youtube_dl
from typing import List


DIR = os.path.dirname(os.path.abspath(__file__))


def videos_list(file: str) -> List[str]:
    try:
        with open(os.path.join(DIR, file)) as fd:
            return fd.read().splitlines()
    except IOError:
        return []


def download_songs(names: List[str]):
    options = {
        'ignoreerrors': True,
        'outtmpl': '%(autonumber)s - %(artist)s - %(track)s.%(ext)s',
    }
    with youtube_dl.YoutubeDL(options) as ydl:
        ydl.download([f'ytsearch:{name}' for name in names])


def main(file_songs):
    download_songs(videos_list(file_songs))


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("File required")
        exit(1)
    try:
        main(sys.argv[1])
    except KeyboardInterrupt:
        print("\nUser interupt")
