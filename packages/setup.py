#!/usr/bin/env python3

import os
import platform
import subprocess
import configparser
from pip._internal import main as pipmain
from typing import List


DIR = os.path.dirname(os.path.abspath(__file__))


def ask(question: str, default: str = None) -> bool:
    def prompt(default):
        prompts = {'Y': ('Y/n', 'Y'), 'N': ('y/N', 'N')}
        try:
            return prompts[default]
        except KeyError:
            return ('y/n', '')

    def get_reply(question, default):
        reply = input(question)
        return reply if reply else default

    def answer(reply):
        answers = {'y': True, 'Y': True, 'n': False, 'N': False}
        try:
            return answers[reply[0]]
        except KeyError:
            return None
        except IndexError:
            return None

    def keep_asking(question, default):
        while True:
            reply = answer(get_reply(question, default))
            if reply in [True, False]:
                return reply

    prompt, default = prompt(default)
    return keep_asking(f"{question} [{prompt}] ", default)


def distro_id() -> str:
    """
    Only works for recent distros using systemd new scheme.
    (debian, ubuntu, arch, fedora)
    """
    section = 's'

    def fake_read(fp):
        yield f'[{section}]\n'
        yield from fp
    cfg = configparser.ConfigParser()
    with open('/etc/os-release') as fp:
        cfg.read_file(fake_read(fp))
    return cfg[section]['ID'].strip('"')


def has(executable: str) -> bool:
    for dir in os.environ['PATH'].split(path_sep):
        if os.path.isfile(os.path.join(dir, executable)):
            return True
    return False


def get_packages(file: str) -> List[str]:
    with open(os.path.join(DIR, file)) as packages:
        return packages.read().splitlines()


def run(command: str, args=[]) -> subprocess.CompletedProcess:
    cp = subprocess.run(command.split(' ') + args)
    if cp.returncode != 0:
        raise Exception('Error')
    return cp


def ps1_run(command: str, args=[]) -> subprocess.CompletedProcess:
    powershell = 'C:\\WINDOWS\\system32\\WindowsPowerShell\\v1.0\\powershell.exe'
    return run(f'{powershell} {command}', args)


def linux():
    def install(update: str, install: str, packages: List[str]):
        run(update)
        run(install, packages)

    def apt():
        install(
            'sudo apt-get update -q',
            'sudo apt-get -q install',
            get_packages('apt')
        )

    def pacman():
        install(
            'sudo pacman -Syyq',
            'sudo pacman -Sq',
            get_packages('pacman')
        )

    distro = {
        'ubuntu': apt,
        'debian': apt,
        'arch': pacman,
    }

    if has('sudo') and ask("Install system packages ?", 'N'):
        distro[distro_id()]()


def pip_setup():
    def install(packages: List[str]):
        pipmain(['install', '--user', '--upgrade', 'pip'])
        pipmain(['install', '--user'] + packages)

    if ask("Install pip packages ?", 'N'):
        install(get_packages('pip'))


def npm_setup():
    def install(packages: List[str]):
        run(npm_exe + ' install -g', packages)

    if has(npm_exe) and ask("Install npm packages ?", 'N'):
        install(get_packages('npm'))


def windows():
    def install_scoop():
        ps1_run('Set-ExecutionPolicy RemoteSigned -scope CurrentUser')
        url = 'https://get.scoop.sh'
        ps1_run(f"iex (new-object net.webclient).downloadstring('{url}')")

    def install(packages: List[str]):
        ps1_run('scoop install', packages)

    if not has('scoop') and ask("Install scoop ?", 'N'):
        install_scoop()

    if has('scoop') and ask("Install scoop packages ?", 'N'):
        install(get_packages('scoop'))


systems = {
    'Linux': (linux, ':', 'npm'),
    'Windows': (windows, ';', 'npm.cmd'),
}

system_setup, path_sep, npm_exe = systems[platform.system()]


def main():
    system_setup()
    pip_setup()
    npm_setup()


if __name__ == '__main__':
    main()
