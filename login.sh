#!/bin/bash

#login.sh

source 'api/bashlib.sh'
source 'api/login.sh'
source 'api/sqlite.sh'

mode=$(param a)
if [ -z $mode ]; then
  source 'api/header.sh'
  cat html/login.html
  exit
fi
if [ $nick == "anonymous" ]; then
  post_user=$(param nick)
  post_passwd=$(param passwd)
  passwd=$(get_password $post_user)
  if [ $passwd == $post_passwd ]; then
    newsid=$(random_seed)
    source 'api/header.sh' "nick=$post_user" "sid=$newsid"
    sqlite3 $DBFILE "UPDATE users SET sid='$newsid' WHERE nick='$post_user'"
    nick=$post_user
    echo success
  else
    source 'api/header.sh'
    echo fail
  fi
else
  source 'api/header.sh'
fi
