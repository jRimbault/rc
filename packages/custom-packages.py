"""Installation of packages not available in standard repositories"""
import json
import os
import shutil
import tarfile
import tempfile
import urllib.request


def get(url):
    r = urllib.request.urlopen(url)
    return json.loads(r.read())


def dl_targz_to_tmp(url, dest):
    tmp_file, _ = urllib.request.urlretrieve(url)
    tar = tarfile.open(tmp_file)
    tar.extractall(dest)
    tar.close()


def move_to_localbin(file, dest=None):
    if dest is None:
        dest = os.path.basename(file)
    localbin = os.path.join(os.environ["HOME"], os.path.join(".local", "bin"))
    shutil.move(file, os.path.join(localbin, dest))


def download_bin(url, name):
    with tempfile.TemporaryDirectory() as tmpdir:
        dl_targz_to_tmp(url, tmpdir)
        move_to_localbin(os.path.join(tmpdir, name))


def package_fzf():
    def package_url():
        api = get(r"https://api.github.com/repos/junegunn/fzf-bin/releases/latest")
        linux_amd64, = [asset
                        for asset in api["assets"]
                        if "linux_amd64" in asset["name"]]
        return linux_amd64["browser_download_url"]

    download_bin(package_url(), "fzf")


def main():
    package_fzf()


if __name__ == "__main__":
    main()
