#!/usr/bin/env python3

import asyncio
import aiohttp
import time
import datetime


urls = [
    'https://www.google.com',
    'https://www.yandex.ru',
    'https://jrimbault.io',
    'https://www.python.org',
]

res = {}


async def fetch(session, url):
    async with session.get(url) as response:
        return await response.text()


async def call_url(url):
    client_session = aiohttp.ClientSession
    connector = aiohttp.TCPConnector
    print(f'Starting {url}')
    start = time.time()
    start = datetime.datetime.today()
    async with client_session(connector=connector(ssl=False)) as session:
        data = await fetch(session, url)
    res[url] = (start, datetime.datetime.today())
    print(f'{url}: {len(data)} bytes')
    return data


def main():
    futures = [call_url(url) for url in urls]
    asyncio.run(asyncio.wait(futures))
    print(res)


if __name__ == "__main__":
    main()
