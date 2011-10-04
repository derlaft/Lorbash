#!/bin/bash

#api/sqlite.sh

# function makes query to database
function make_array {
  echo $* | sed -e 's/|/ /g'
}

function make_number {
  echo $* | sed -e 's/[^ 0-9]//g'
}

function get_time {
  date +%s
}

function get_time_string {
  date -d "@$@" +"%H:%M:%S %D"
}

function make_safe {
  echo "$@" | sed -e 's/</&lt\;/g;s/>/&gt\;/g;s/&/&amp\;/g;' 
}

function get_title {
  
  #just return post title
  post_id=$(make_number $1)
  sqlite3 "$DBFILE" "SELECT title FROM posts WHERE id='$post_id'"
}

function check_post {
  
  type=$(sqlite3 "$DBFILE" "SELECT type FROM posts WHERE id='$1'")
  echo "$type"
}

function get_gparent {

  make_number $(sqlite3 "$DBFILE" "SELECT globalparent FROM posts WHERE id='$1'")
}

function get_post_vars {
#function will get all information about post

  #avaiable rows are:
  # (id, title, body, type, globalparent, parent, data)
  
  if [ -n $(make_number $1) ]; then

    body=$(sqlite3 "$DBFILE" "SELECT body FROM posts WHERE id='$post_id'")
    title=$(sqlite3 "$DBFILE" "SELECT title FROM posts WHERE id='$post_id'")
    parent=$(make_number $(sqlite3 "$DBFILE" "SELECT parent FROM posts WHERE id='$post_id'"))
    type=$(sqlite3 "$DBFILE" "SELECT type FROM posts WHERE id='$post_id'")
  
    if [ -n "$parent" ] && [ "$type" == 'post' ]; then

      parent_author=$(sqlite3 "$DBFILE" "SELECT author FROM posts WHERE id='$parent'")
      parent_date=$(get_time_string $(sqlite3 "$DBFILE" "SELECT date FROM posts WHERE id='$parent'"))
    fi

    if [ "$type" == "deleted_post" ] || [ "$type" == "deleted_thread" ]; then

      dreason=$(sqlite3 "$DBFILE" "SELECT dreason FROM posts WHERE id='$post_id'")
      dauthor=$(sqlite3 "$DBFILE" "SELECT dauthor FROM posts WHERE id='$post_id'")
    fi

    author=$(sqlite3 "$DBFILE" "SELECT author FROM posts WHERE id='$post_id'")
    date=$(get_time_string $(sqlite3 "$DBFILE" "SELECT date FROM posts WHERE id='$post_id'"))
    
    #that's all, heh
  fi
}

function get_user_vars {

  id=$(sqlite3 "$DBFILE" "SELECT id FROM users WHERE nick='$1'")
  userinfo=$(sqlite3 "$DBFILE" "SELECT userinfo FROM users WHERE nick='$1'")
  reg=$(sqlite3 "$DBFILE" "SELECT reg FROM users WHERE nick='$1'")
  state=$(get_user_state $1)
}

function get_user_state {

  reg=$(sqlite3 "$DBFILE" "SELECT type FROM users WHERE nick='$1'")
}
