#!/usr/bin/env python3

import os
from aiohttp import web


class Http:
    def __init__(self, app: web.Application):
        self.app = app
        self._default()

    def _default(self):
        self.app.add_routes([
            web.get('/', self.handle),
            web.get('/{name}', self.handle)
        ])

    def run(self):
        web.run_app(self.app)

    async def handle(self, request):
        name = request.match_info.get('name', "Anonymous")
        text = "Hello, " + name
        return web.Response(text=text)


def main():
    app = Http(web.Application())
    app.run()


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print()
