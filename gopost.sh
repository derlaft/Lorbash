#!/bin/bash

#gopost.sh

source 'api/bashlib.sh'
source 'api/login.sh'
source 'api/viewpost.sh'

post_id=$(make_number $(param id))

if [ -n "$post_id" ]; then
  type=$(sqlite3 "$DBFILE" "SELECT type FROM posts WHERE id='$post_id'")
  if [ "$type" == 'post' ]; then
    parent=$(make_number $(sqlite3 "$DBFILE" "SELECT globalparent FROM posts WHERE id='$post_id'"))
    source 'api/redirect.sh'  "thread.sh?id=$parent#$post_id"
    exit
  elif [ "$type" == 'thread' ]; then 
    source 'api/redirect.sh' "thread.sh?id=$post_id#$post_id"
    exit
  fi
fi

source 'api/header.sh'
cat 'html/header.html' | sed -e 's/@@TITLE@@/404/'
echo '<b>404</b>'
cat 'html/footer.html'
