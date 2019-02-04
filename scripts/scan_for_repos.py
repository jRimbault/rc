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
    repos = find_repos(args.dir)
    if not args.status:
        print(*repos, sep="\n")
        sys.exit(0)

    padding = len(max(repos, key=len)) + 2
    tasks = [git_repo(args.dir, repo, "status") for repo in repos]
    for task in asyncio.as_completed(tasks):
        repo, out = await task
        print(f"{repo:<{padding}}: {message(out)}", flush=True)


def find_repos(base_dir):
    def clean(filename):
        return filename[len(base_dir) : -4].strip("/")

    search_glob = os.path.join(base_dir, "**/.git")
    return [clean(f) for f in glob.iglob(search_glob, recursive=True)]


def async_io(func):
    @wraps(func)
    def threaded_executor(*args):
        return LOOP.run_in_executor(None, func, *args)

    return threaded_executor


@async_io
def git_repo(base_dir, repo, command):
    gitdir = os.path.join(base_dir, os.path.join(repo, ".git"))
    command = (
        "git",
        "--git-dir",
        gitdir,
        "--work-tree",
        os.path.join(base_dir, repo),
        command,
    )
    return repo, run(command)


class Colors:
    OKBLUE = "\033[94m"  # write operation succeeded
    OKGREEN = "\033[92m"  # readonly operation succeeded
    OKPURPLE = "\033[95m"  # readonly (fetch) operation succeeded
    WARNING = "\033[93m"  # operation succeeded with non-default result
    FAIL = "\033[91m"  # operation did not succeed
    ENDC = "\033[0m"  # reset color


def colorize(color, message):
    return "{0}{1}{2}".format(color, message, Colors.ENDC)


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


def parse_args(argv):
    p = argparse.ArgumentParser()
    p.add_argument("dir", help="directory to parse sub dirs from")
    p.add_argument(
        "-s", "--status", help="fetch repository status", action="store_true"
    )
    return p.parse_known_args(argv)


if __name__ == "__main__":
    LOOP.run_until_complete(main(*parse_args(sys.argv[1:])))
