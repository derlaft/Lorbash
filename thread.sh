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
    echo '<div id="bd">'
    echo "<div class=messages>"
    get_post "$thread_id" 'thread'
    page=$(make_number $(param page))
    if [ -z "$page" ]; then
      answers=$(sqlite3 "$DBFILE" "SELECT id FROM posts WHERE globalparent=$thread_id AND type='post'" )
    elif [ "$page" -eq "-1" ]; then
      answers=$(sqlite3 "$DBFILE" "SELECT id FROM posts WHERE globalparent=$thread_id AND type='post'" )
    else
      offset=$("$page \* 50" | bc -q)
      answers=$(sqlite3 "$DBFILE" "SELECT id FROM posts WHERE globalparent=$thread_id AND type='post' LIMIT 50 OFFSET $offset")
    fi
    for answer in $answers; do
      get_post "$answer" 'post'
    done
    echo "</div></div>"
  else
    echo "<b>404</b>"
  fi
  
fi

page_html 'footer'
