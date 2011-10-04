#!/bin/bash

#check username
user=$(cookie nick)
sid=$(cookie sid)

if [ -n "$user" ] && [ -n "$sid" ]; then
  chsid=$( sqlite3 "$DBFILE" "SELECT sid FROM users WHERE nick='$user'" )
  if [ "$sid" == "$chsid" ]; then
    nick=$user
  fi
fi
[ -z "$nick" ] && nick="anonymous"

function random_seed {
  echo $[ "$RANDOM" * "$RANDOM" ] | sha1sum  | tr ' ' '\n' | sed -n 1p
}

function get_password {
  sqlite3 "$DBFILE" "SELECT passwd FROM users WHERE nick='$1'"
}

function get_state {
  sqlite3 "$DBFILE" "SELECT state FROM users WHERE nick='$1'"
}
