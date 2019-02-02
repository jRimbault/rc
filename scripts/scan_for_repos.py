#!/usr/bin/env python3

import argparse
import asyncio
import glob
import os
import re
import subprocess
import sys
from functools import wraps

LOOP = asyncio.get_event_loop()


async def main(args, argv):
    tasks = [show_repos(args.dir, repo) for repo in find_repos(args.dir)]
    for task in tasks:
        print(await task, flush=True)


async def show_repos(base_dir, repo):
    status = await get_repo_status(os.path.join(base_dir, repo))
    return f"{repo:<50}: {status}"


def async_t(func):
    @wraps(func)
    def threaded_executor(*args):
        return LOOP.run_in_executor(None, func, *args)

    return threaded_executor


class Colors:
    BOLD = "\033[1m"  # unused
    UNDERLINE = "\033[4m"  # unused
    HEADER = "\033[95m"  # unused
    OKBLUE = "\033[94m"  # write operation succeeded
    OKGREEN = "\033[92m"  # readonly operation succeeded
    OKPURPLE = "\033[95m"  # readonly (fetch) operation succeeded
    WARNING = "\033[93m"  # operation succeeded with non-default result
    FAIL = "\033[91m"  # operation did not succeed
    ENDC = "\033[0m"  # reset color

    # list of all colors
    ALL = [BOLD, UNDERLINE, HEADER, OKBLUE, OKGREEN, OKPURPLE, WARNING, FAIL, ENDC]

    # map from ASCII to Windows color text attribute
    WIN_DICT = {
        BOLD: 15,
        UNDERLINE: 15,
        HEADER: 15,
        OKBLUE: 11,
        OKGREEN: 10,
        WARNING: 14,
        FAIL: 12,
        ENDC: 15,
    }


def colorize(color, message):
    return "%s%s%s" % (color, message, Colors.ENDC)


def message(out):
    messages = []
    clean = True
    # changed from "directory" to "tree" in git 2.9.1
    # https://github.com/mnagel/clustergit/issues/18
    if "On branch master" not in out:
        branch = out.splitlines()[0].replace("On branch ", "")
        messages.append(colorize(Colors.WARNING, "On branch %s" % branch))
        clean = False
    # changed from "directory" to "tree" in git 2.9.1
    # https://github.com/mnagel/clustergit/issues/18
    if re.search(r"nothing to commit.?.?working (directory|tree) clean.?", out):
        messages.append(colorize(Colors.OKBLUE, "No Changes"))
    elif "nothing added to commit but untracked files present" in out:
        messages.append(colorize(Colors.WARNING, "Untracked files"))
        clean = False
    else:
        messages.append(colorize(Colors.FAIL, "Changes"))
        clean = False
    if "Your branch is ahead of" in out:
        messages.append(colorize(Colors.FAIL, "Unpushed commits"))
        clean = False

    if clean:
        messages = [colorize(Colors.OKGREEN, "Clean")]

    return ", ".join(messages)


@async_t
def get_repo_status(repo):
    gitdir = os.path.join(repo, ".git")
    command = ["git", "--git-dir", gitdir, "--work-tree", repo, "status"]
    out = run(command)

    return message(out)


def run(command):
    try:
        output = subprocess.check_output(command)
        if isinstance(output, bytes):
            output = output.decode("utf-8")
        return output
    except subprocess.CalledProcessError as e:
        if isinstance(e.output, bytes):
            e.output = e.output.decode("utf-8")
        return e.output


def find_repos(base_dir):
    def clean(filename):
        return filename[len(base_dir) : -4].strip("/")

    search_glob = os.path.join(base_dir, "**/.git")
    for filename in glob.iglob(search_glob, recursive=True):
        yield clean(filename)


def parse_args(argv):
    p = argparse.ArgumentParser()
    p.add_argument(
        "dir",
        help="directory to parse sub dirs from. (default: .)",
        default=".",
    )
    return p.parse_known_args(argv)


if __name__ == "__main__":
    LOOP.run_until_complete(main(*parse_args(sys.argv[1:])))
