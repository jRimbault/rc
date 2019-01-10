#!/usr/bin/env bash
#/ Script Name: lock.sh
#/ Edited from https://github.com/meskarune/i3lock-fancy
#/ Author: Dolores Portalatin (meskarune)
#/ Author: jRimbault
#/ Date:   2017-06-08
#/
#/ Description:
#/   Use i3lock to display a pretty lockscreen
#/
#/ Usage: lock.sh
#/   You'll have to edit the overlay location inside the script
#/   for the new mode to work.
#/
#/ Options:
#/   -h, --help   display this help
#/   -o, --old    use older, slower lockscreen, depends on i3lock-fancy
#/   -x, --xkcd   display a random xkcd comic strip on each lock, needs internet
#/
#/ Dependencies:
#/   ffmpeg
#/   imagemagick
#/   i3lock-color-git
#/   scrot
#/   wmctrl (optional)
#/   i3lock-fancy (optional)
#/   curl (optional)
usage()
{
  grep "^#/" "$0" | cut -c4-
  exit 0
}

set -euo pipefail
IFS=$'\n\t'

# get real path where the script is located
readonly scriptlink=$(readlink -f -- "$0")
readonly scriptpath=${scriptlink%/*}
# tmp file
readonly image="$(mktemp --suffix=.png)"

build_lockscreen()
{
  ffmpeg -loglevel quiet -y -s 1920x1080 -f x11grab -i "$DISPLAY" -vframes 1 -vf "gblur=sigma=16" "$image"
  convert "$image" "$overlay" -gravity center -composite "$image"
}

lock_old()
{
  i3lock-fancy -t "I AM LOCKED" -f "Source-Code-Pro-for-Powerline" -- maim
  exit 0
}

get_xkcd_url()
{
  curl -sL "http://dynamic.xkcd.com/random/comic/" |
  grep -o "https://imgs.xkcd.com/comics/[^ ]*"
}

lock_xkcd()
{
  overlay="$(mktemp --suffix=.xkcd.png)"
  curl -s "$(get_xkcd_url)" -o "$overlay"
  build_lockscreen
  # rrggbbaa format, channels: red, green, blue, alpha
  declare -ra params=(
    "--textcolor=00000000"
    "--insidecolor=00000000"
    "--ringcolor=00000000"
    "--linecolor=00000000"
    "--keyhlcolor=00000000"
    "--ringvercolor=00000000"
    "--separatorcolor=00000000"
    "--insidevercolor=00000000"
    "--ringwrongcolor=00000000"
    "--insidewrongcolor=00000000"
  )
  i3lock "${params[@]}" -i "$image"
  exit 0
}

lock_new()
{
  overlay="$BSWPM_BG_LOCK"
  build_lockscreen
  # rrggbbaa format, channels: red, green, blue, alpha
  declare -ra params=(
    "--textcolor=00000000"
    "--insidecolor=00000000"
    "--ringcolor=fafafaff"
    "--linecolor=00000000"
    "--keyhlcolor=fabb5cff"
    "--ringvercolor=fadd5cff"
    "--separatorcolor=00000000"
    "--insidevercolor=00000000"
    "--ringwrongcolor=f13459ff"
    "--insidewrongcolor=00000000"
  )
  i3lock "${params[@]}" -i "$image"
  exit 0
}

args()
{
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        usage
        ;;
      -o|--old)
        lock_old
        ;;
      -x|--xkcd)
        lock_xkcd
        ;;
    esac
    shift
  done
}

# executes only when executed directly not sourced
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  # don't execute if already running
  pgrep i3lock > /dev/null && exit 1
  pgrep wayland > /dev/null && exit 1
  args "$@"
  lock_new
fi
