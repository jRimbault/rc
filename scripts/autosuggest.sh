#!/usr/bin/env bash

google()
{
  curl -sS "https://suggestqueries.google.com/complete/search?client=firefox&q=$1" \
    | sed -E 's,.*\[([^]]*)\].*,\1,;s,",,g' | tr , '\n'
}
duckgo()
{
  curl -sS "https://duckduckgo.com/ac/?q=$1" \
    | sed -E 's,"phrase":|[][{}"],,g' | tr , '\n'
}

autosuggest()
{
  S="$(echo "$@" | sed -E 's, +,+,g')"
  echo -e "Google:"
  google "$S"
  echo ""
  echo -e "Duckduckgo:"
  duckgo "$S"
  echo ""
  #paste -d , <(google $S) <(duckgo $S) | column -t -s ,
}

if [[ -n "$*" ]]; then
	autosuggest "$@"
fi
