#!/usr/bin/env python3

import os
import webbrowser
from configparser import ConfigParser


def git_config():
    git_config_path = os.path.join(os.getcwd(), ".git", "config")
    with open(git_config_path) as git_config_file:
        config_lines = git_config_file.readlines()
    config = ConfigParser()
    config.read_string("".join([line.lstrip() for line in config_lines]))
    return config


def remote_url(uri: str) -> str:
    """
    Todo (never) :
     - actually do something to resolve URLs
    """
    if "https" in uri:
        return uri
    if "git@" in uri:
        return uri.replace(":", "/").replace("git@", "https://")
    return uri


def main():
    config = git_config()
    for section in config:
        if "remote" not in section:
            continue
        webbrowser.open(remote_url(config[section]["url"]))
        break


if __name__ == "__main__":
    main()
