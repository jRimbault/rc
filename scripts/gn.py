#!/usr/bin/env python3
#
# Print a diff summary like:
#
#   $ git diff 'master~10..master' | gn
#   293 lines of diff
#   185 lines (+200, -15)
#   650 words (+10, -660)
#
# or:
#
#   $ gn my-awesome-patch.diff
#   293 lines of diff
#   185 lines (+200, -15)
#   650 words (+10, -660)

import sys
import os
import re
import fileinput


def get_lines(diff_lines):
    # Added lines start with '+' (but not '+++', because that marks a new
    # file).  The same goes for removed lines, except '-' instead of '+'.
    def condition(char):
        return lambda l: l.startswith(char) and not l.startswith(char * 3)
    is_added = condition('+')
    is_removed = condition('-')

    added_lines = [line for line in diff_lines if is_added(line)]
    removed_lines = [line for line in diff_lines if is_removed(line)]

    return added_lines, removed_lines


def get_words(added_lines, removed_lines):
    def word_count(lines):
        return [word
                for line in lines
                for word in line.split()
                if re.match(r'^\w+', word)]

    return word_count(added_lines), word_count(removed_lines)


def display(diff_lines, added_lines, added_words, removed_lines, removed_words):
    print(f'{diff_lines} lines of diff')
    print(f'+{added_lines - removed_lines} lines (+{added_lines}, -{removed_lines})')
    print(f'+{added_words - removed_words} words (+{added_words}, -{removed_words})')


def main(fileinput):
    diff_lines = list(fileinput)
    added_lines, removed_lines = get_lines(diff_lines)
    added_words, removed_words = get_words(added_lines, removed_lines)
    display(
        len(diff_lines),
        len(added_lines),
        len(added_words),
        len(removed_lines),
        len(removed_words)
    )


if __name__ == '__main__':
    main(fileinput.input())
