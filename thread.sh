#!/bin/bash

#thread.sh

source 'api/core.sh' 'header'

thread_id=$(make_number $(param id))
page_html 'header' "$(get_title $thread_id)"

if [ -z "$thread_id" ]; then
  #let's send very informative message
  echo "<b>404</b>"
else 
  type=$(sqlite3 "$DBFILE" "SELECT type FROM posts WHERE id='$thread_id'")
  if [ "$type" == 'thread' ]; then
    echo "<div class=messages>"
    get_post "$thread_id"
    answers=$(sqlite3 "$DBFILE" "SELECT id FROM posts WHERE globalparent=$thread_id LIMIT 50" )
    for answer in $answers; do
      get_post "$answer"
    done
    echo "</div>"
  else
    echo "<b>404</b>"
  fi
  
fi

page_html 'footer'
