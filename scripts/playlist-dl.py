#!/usr/bin/env python3

import os
import sys
import youtube_dl
from typing import List
import argparse


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
    parser = argparse.ArgumentParser()
    parser.add_argument(
        'playlist',
        help='File containing one video title or url per line'
    )
    args = parser.parse_args()
    main(args.playlist)
