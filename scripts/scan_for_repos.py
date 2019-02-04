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
    def clean(filename):
        if args.absolute:
            return filename
        return filename[len(args.dir) :].strip("/")

    def max_padding(repos):
        if args.absolute:
            return max(map(len, repos)) + 1
        return max(map(len, repos)) - len(args.dir)

    repos = find_repos(args.dir)
    if not args.status:
        print(*[clean(repo) for repo in repos], sep="\n")
        return

    padding = max_padding(repos)
    async for repo, status in repos_statuses(repos):
        print(f"{clean(repo):<{padding}}: {status}", flush=True)


async def repos_statuses(repos):
    tasks = [git_repo(repo, "status") for repo in repos]
    for task in asyncio.as_completed(tasks):
        repo, out = await task
        yield repo, status_message(out)


def find_repos(base_dir):
    def clean(filename):
        return filename[:-4].rstrip("/")

    search_glob = os.path.join(base_dir, "**/.git")
    return [clean(f) for f in glob.iglob(search_glob, recursive=True)]


def async_io(func):
    @wraps(func)
    def threaded_executor(*args):
        return LOOP.run_in_executor(None, func, *args)

    return threaded_executor


@async_io
def git_repo(repo, command):
    return repo, run_git_repo(os.path.join(repo), command)


def run_git_repo(repo, action):
    command = ["git", "--git-dir", os.path.join(repo, ".git"), "--work-tree", repo]
    if type(action) == list:
        command += action
    elif type(action) == str:
        command.append(action)
    return run(command)


def status_message(out):
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


class Colors:
    OKBLUE = "\033[94m"  # write operation succeeded
    OKGREEN = "\033[92m"  # readonly operation succeeded
    OKPURPLE = "\033[95m"  # readonly (fetch) operation succeeded
    WARNING = "\033[93m"  # operation succeeded with non-default result
    FAIL = "\033[91m"  # operation did not succeed
    ENDC = "\033[0m"  # reset color


def colorize(color, message):
    if os.name == "nt":
        return message
    return f"{color}{message}{Colors.ENDC}"


def run(command):
    try:
        output = subprocess.check_output(command)
        return output.decode("utf-8")
    except subprocess.CalledProcessError as e:
        return e.output.decode("utf-8")


def parse_args(argv):
    p = argparse.ArgumentParser()
    p.add_argument("dir", help="directory to parse sub dirs from")
    p.add_argument(
        "-s", "--status", help="fetch repository status", action="store_true"
    )
    p.add_argument(
        "-A", "--absolute", help="display absolute paths", action="store_true"
    )
    return p.parse_known_args(argv)


if __name__ == "__main__":
    LOOP.run_until_complete(main(*parse_args(sys.argv[1:])))
