#!/usr/bin/env python3

import os
import sys
import youtube_dl
from typing import List


DIR = os.path.dirname(os.path.abspath(__file__))


def raw_video_list(filename: str) -> List[str]:
    try:
        with open(filename) as fd:
            return fd.read().splitlines()
    except IOError:
        return []


def videos_list(filename: str) -> List[str]:
    videos = raw_video_list(filename)
    if len(videos) == 0:
        print(f'Empty file : {filename}', file=sys.stderr)
        exit(1)
    return [f'ytsearch:{video}' if 'http' not in video else video for video in videos]


def download_videos(dest: str, videos: List[str]) -> str:
    options = {
        'ignoreerrors': True,
        'outtmpl': os.path.join(dest, '%(autonumber)s - %(title)s.%(ext)s'),
    }
    with youtube_dl.YoutubeDL(options) as ydl:
        ydl.download(videos)

    return dest


def write_playlist(dest: str):
    with open(os.path.join(dest, 'playlist.m3u8'), 'w') as fd:
        fd.write('\n'.join(os.listdir(dest)[:-1]))


def main(file_videos):
    write_playlist(download_videos(
        os.path.join(os.path.dirname(file_videos), file_videos + '-dl'),
        videos_list(file_videos)
    ))


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("File required", file=sys.stderr)
        exit(1)
    if not os.path.isfile(sys.argv[1]):
        print("Valid file required", file=sys.stderr)
        exit(1)
    try:
        main(os.path.realpath(sys.argv[1]))
    except KeyboardInterrupt:
        print("\nUser interupt", file=sys.stderr)
