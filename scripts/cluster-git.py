#!/usr/bin/env python3

""" run git commands on multiple git clones
inspired by https://github.com/mnagel/clustergit """

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

    def _print(repo, status):
        if args.hide_clean and "Clean" in status:
            return
        print(f"{clean(repo):<{padding}}: {status}", flush=True)

    async def loop(method):
        async for repo, status in method(repos):
            _print(repo, status)

    repos = find_repos(args.dir)
    padding = max_padding(repos)

    if args.status:
        await loop(repos_statuses)
    elif args.fetch:
        await loop(repos_fetch)
    elif args.pull:
        await loop(repos_pull)
    elif args.push:
        await loop(repos_push)
    else:
        print(*[clean(repo) for repo in repos], sep="\n")


async def repos_statuses(repos):
    git_status = as_completed(git_repo("status"))
    for task in git_status(repos):
        _, repo, out = await task
        yield repo, status_message(out)


async def repos_fetch(repos):
    git_status = run_in_repo("status")
    git_fetch = as_completed(git_repo(["fetch", "--all"]))
    for task in git_fetch(repos):
        errcode, repo, out = await task
        _, status = git_status(repo)
        yield repo, status_message(status) + ", " + fetch_message(errcode, out)


async def repos_pull(repos):
    git_pull = as_completed(git_repo("pull"))
    for task in git_pull(repos):
        out = "No action taken"
        _, repo, out = await task
        yield repo, pull_message(out)


async def repos_push(repos):
    git_push = as_completed(git_repo("push"))
    for task in git_push(repos):
        _, repo, out = await task
        yield repo, push_message(out)


def as_completed(method):
    def inner(iterable):
        return asyncio.as_completed([method(i) for i in iterable])

    return inner


def find_repos(base_dir):
    search_glob = os.path.join(base_dir, "**/.git")
    return [f[:-5] for f in glob.glob(search_glob, recursive=True)]


def async_io(func):
    @wraps(func)
    def threaded_executor(*args):
        return LOOP.run_in_executor(None, func, *args)

    return threaded_executor


def git_repo(action):
    @async_io
    def inner(repo):
        status, out = run_git_repo(repo, action)
        return status, repo, out

    return inner


def run_in_repo(action):
    def inner(repo):
        return run_git_repo(repo, action)

    return inner


def run_git_repo(repo, action):
    command = ["git", "--git-dir", os.path.join(repo, ".git"), "--work-tree", repo]
    if type(action) == list:
        command += action
    elif type(action) == str:
        command.append(action)
    return run(command)


def fetch_message(errcode, out):
    fetch = []
    if "error: " in out:
        fetch.append(colorize(Colors.FAIL, "Fetch fatal"))
    else:
        fetch.append(colorize(Colors.OKPURPLE, "Fetched"))
    if errcode != 0:
        fetch.append(colorize(Colors.FAIL, "Fetch unsuccessful"))
    return ", ".join(fetch)


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


def pull_message(out):
    if out == "No action taken":
        return out

    messages = []
    if re.search(r"Already up.to.date", out):
        messages.append(colorize(Colors.OKGREEN, "Pulled nothing"))
    elif "CONFLICT" in out:
        messages.append(colorize(Colors.FAIL, "Pull conflict"))
    elif "fatal: No remote repository specified." in out:
        messages.append(colorize(Colors.WARNING, "Pull remote not configured"))
    elif "fatal: " in out:
        messages.append(colorize(Colors.FAIL, "Pull fatal"))
    elif "error: " in out:
        messages.append(colorize(Colors.FAIL, "Pull error"))
    else:
        messages.append(colorize(Colors.OKBLUE, "Pulled"))

    return ", ".join(messages)


def push_message(out):
    if re.search(r"\[(remote )?rejected\]", out):
        return colorize(Colors.FAIL, "Push rejected")
    if "denied" in out:
        return colorize(Colors.FAIL, "Denied permission")

    return colorize(Colors.OKBLUE, "Pushed OK")


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
        output = subprocess.check_output(command, stderr=subprocess.STDOUT)
        return 0, output.decode("utf-8")
    except subprocess.CalledProcessError as e:
        return e.returncode, e.output.decode("utf-8")


def parse_args(argv):
    parser = argparse.ArgumentParser(
        description="""
        {0} will scan through all subdirectories looking for a .git directory.
        When it finds one it'll look to see if there are any changes and let you know.
        """.format(
            os.path.basename(__file__)
        ).strip()
        # If there are no changes it can also push and pull to/from a remote location.
    )
    parser.add_argument("dir", help="directory to parse sub dirs from")
    actions = parser.add_mutually_exclusive_group()
    actions.add_argument("-s", "--status", help="show status", action="store_true")
    actions.add_argument("-f", "--fetch", help="fetch from remote", action="store_true")
    actions.add_argument("-p", "--pull", help="pull from remote", action="store_true")
    actions.add_argument("-P", "--push", help="push to remote", action="store_true")
    parser.add_argument(
        "-A", "--absolute", help="display absolute paths", action="store_true"
    )
    parser.add_argument(
        "-H", "--hide-clean", help="hide clean repos", action="store_true"
    )
    return parser.parse_known_args(argv)


if __name__ == "__main__":
    try:
        LOOP.run_until_complete(main(*parse_args(sys.argv[1:])))
    except KeyboardInterrupt:
        print()
