#!/usr/bin/env python3
"""Installation of packages not available in standard repositories"""
import io
import json
import os
import shutil
import sys
import tarfile
import tempfile
from urllib.request import urlopen


def main():
    package_fzf()
    package_clustergit()


def get(url):
    r = urlopen(url)
    return json.loads(r.read())


def mkdir(d):
    if not os.path.exists(d):
        print("mkdir", d)
        os.mkdir(d)


def local_bin_dir():
    home = os.path.expanduser("~")
    local = os.path.join(home, ".local")
    mkdir(local)
    local_bin = os.path.join(local, "bin")
    mkdir(local_bin)
    return local_bin


def download_with_progress(url):
    print("Downloading", url)

    remote_file = urlopen(url)
    total_size = int(remote_file.headers["Content-Length"].strip())

    data = []
    bytes_read = 0.0

    while True:
        d = remote_file.read(8192)

        if not d:
            print()
            break

        bytes_read += len(d)
        data.append(d)
        print(f"\r{(bytes_read / total_size * 100):6.2f}% downloaded", end=" ")

    return b"".join(data)


def package_fzf():
    api_url = r"https://api.github.com/repos/junegunn/fzf-bin/releases/latest"
    binary = "fzf"

    def package_url():
        linux_amd64, = [
            asset["browser_download_url"]
            for asset in get(api_url)["assets"]
            if "linux_amd64" in asset["name"]
        ]
        return linux_amd64

    dest = os.path.join(local_bin_dir(), binary)

    with tempfile.TemporaryDirectory() as tmpdir:
        compressed = download_with_progress(package_url())
        with tarfile.open(fileobj=io.BytesIO(compressed)) as tar:
            tar.extractall(tmpdir)
        shutil.move(os.path.join(tmpdir, binary), dest)

    os.chmod(dest, 0o744)
    print(binary, "installed to", dest)


def package_clustergit():
    script_url = (
        r"https://raw.githubusercontent.com/jRimbault/clustergit/master/clustergit"
    )
    binary = "clustergit"
    dest = os.path.join(local_bin_dir(), binary)
    with open(dest, "wb") as f:
        f.write(download_with_progress(script_url))
    os.chmod(dest, 0o744)
    print(binary, "installed to", dest)


if __name__ == "__main__":
    main()
