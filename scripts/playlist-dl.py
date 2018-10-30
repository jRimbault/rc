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
    return [
        f'ytsearch:{video}' if 'http' not in video else video
        for video in raw_video_list(filename)
    ]


def download_videos(dest: str, videos: List[str], extract_audio: bool) -> str:
    options = {
        'ignoreerrors': True,
        'extractaudio': extract_audio,
        'audioformat': 'best',
        'outtmpl': f'{dest}/%(autonumber)s - %(title)s.%(ext)s',
    }
    with youtube_dl.YoutubeDL(options) as ydl:
        ydl.download(videos)

    return dest


def write_playlist(dest: str):
    list_of_songs = os.listdir(dest)
    with open(os.path.join(dest, 'playlist.m3u8'), 'w') as fd:
        fd.write('\n'.join(list_of_songs))


def main(args):
    playlist = os.path.abspath(args.playlist)
    write_playlist(download_videos(
        os.path.join(os.path.dirname(playlist), playlist + '-dl'),
        videos_list(playlist),
        args.extract_audio
    ))


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        'playlist',
        help='File containing one video title or url per line'
    )
    parser.add_argument(
        '-x',
        '--extract-audio',
        action='store_true',
        help='Only keep audio'
    )
    main(parser.parse_args())
