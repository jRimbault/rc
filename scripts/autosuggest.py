#!/usr/bin/env python3

import itertools
import json
import sys
import urllib.parse
import urllib.request


def ask_get_api(base_url: str, params: dict) -> dict:
    url = base_url + urllib.parse.urlencode(params)
    r = urllib.request.urlopen(url, timeout=10)
    return json.loads(r.read())


def ask_google(params: dict):
    base = r"https://suggestqueries.google.com/complete/search?"
    params["client"] = "firefox"
    yield from ask_get_api(base, params)[1]


def ask_duckduckgo(params: dict):
    base = r"https://duckduckgo.com/ac/?"
    return (t["phrase"] for t in ask_get_api(base, params))


def main(argv: list):
    params = {"q": " ".join(argv)}
    result = itertools.chain(ask_google(params), ask_duckduckgo(params))
    print("\n".join(sorted(set(result))))


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
