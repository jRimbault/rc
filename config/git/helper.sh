#!/bin/bash

# Control character, this is not a space, it's an EM SPACE
# U+2003
CCHAR=' '
# u+2007
CDATE=' '

# Log output:
#
# * 51c333e  12 days  Gary Bernhardt   add vim-eunuch
#
# Branch output:
#
# * release/v1.1  13 days  Leyan Lo   add pretty_git_branch
#
# The time massaging regexes start with ^[^$CCDATE]* because that ensures that they
# only operate before the first "$CCDATE". That "$CCDATE" will be the beginning of the
# author name, ensuring that we don't destroy anything in the commit message
# that looks like time.
#
# The log format uses $CCHAR characters between each field, and `column` is later
# used to split on them. A $CCHAR in the commit subject or any other field will
# break this.

LOG_HASH="%C(always,red)%h%C(always,reset)"
LOG_RELATIVE_TIME="%C(always,green)%ar$CDATE%C(always,reset)"
LOG_AUTHOR="%C(always,blue)%an%C(always,reset)"
LOG_SUBJECT="%s"
LOG_REFS="%C(always,yellow)%d%C(always,reset)"

LOG_FORMAT="$LOG_HASH$CCHAR$LOG_RELATIVE_TIME$CCHAR$LOG_AUTHOR$CCHAR$LOG_SUBJECT$LOG_REFS"

BRANCH_PREFIX="%(HEAD)"
BRANCH_REF="%(color:red)%(refname:short)%(color:reset)"
BRANCH_HASH="%(color:yellow)%(objectname:short)%(color:reset)"
BRANCH_DATE="%(color:green)%(committerdate:relative)$CDATE%(color:reset)"
BRANCH_AUTHOR="%(color:blue)%(authorname)%(color:reset)"
BRANCH_CONTENTS="%(contents:subject)"

BRANCH_FORMAT="$BRANCH_PREFIX$CCHAR$BRANCH_REF$CCHAR$CCHAR$BRANCH_DATE$CCHAR$BRANCH_AUTHOR$CCHAR$BRANCH_CONTENTS"

show_git_head() {
  pretty_git_log -1
  git show -p --pretty="tformat:"
}

pretty_git_log() {
  git log \
    --graph \
    --pretty="tformat:$LOG_FORMAT" $* |
    pretty_git_format |
    git_page_maybe
}

pretty_git_branch() {
  git branch \
    --color=always \
    --format="$BRANCH_FORMAT" $* |
    pretty_git_format
}

pretty_git_branch_sorted() {
  git branch \
    --color=always \
    --sort=-committerdate \
    --format="$BRANCH_FORMAT" $* |
    pretty_git_format
}

pretty_git_format() {
  # Replace (2 years ago) with (2 years)
  sed -Ee "s/(^[^$CDATE]*) ago$CDATE/\\1$CDATE/" |
  # Replace (2 years, 5 months) with (2 years)
  sed -Ee "s/(^[^$CDATE]*), [[:digit:]]+ .*months?$CDATE/\\1/" |
  sed "s/$CDATE//" |
  # Line columns up based on } delimiter
  column -s "$CCHAR" -t
}

git_page_maybe() {
  # Page only if we're asked to.
  if [ -n "$GIT_NO_PAGER" ]; then
    cat
  else
    # Page only if needed.
    less --quit-if-one-screen --no-init --RAW-CONTROL-CHARS --chop-long-lines
  fi
}
