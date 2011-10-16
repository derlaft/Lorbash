#!/bin/bash

#gopost.sh

source 'api/core.sh'

post_id=$(make_number $(param id))

if [ -n "$post_id" ]; then
  type=$(sqlite3 "$DBFILE" "SELECT type FROM posts WHERE id='$post_id'")
  if [ "$type" == 'post' ]; then
    parent=$(make_number $(get_gparent $post_id))
    source 'api/redirect.sh'  "thread.sh?id=$parent#$post_id"
    exit
  elif [ "$type" == 'thread' ]; then
    source 'api/redirect.sh' "thread.sh?id=$post_id#$post_id"
    exit
  fi
fi

source 'api/header.sh'
page_html 'header' '404'
echo '<b>404</b>'
page_html 'footer'
