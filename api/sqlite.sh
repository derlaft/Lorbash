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
  if [ "$2" == 'body' ]; then
    echo -e "$@" | sed -e 's/\&/\&amp/g' | sed -e 's/</\&lt\;/g;s/>/\&gt\;/g;s/\[br\]/\<br\>/g;' 
  else
    echo -e "$@" | sed -e 's/\&/\&amp/g' | sed -e 's/</\&lt\;/g;s/>/\&gt\;/g' 
  fi
}

function get_title {
  
  #just return post title
  post_id=$(make_number $1)
  sqlite3 "$DBFILE" "SELECT title FROM posts WHERE id='$post_id'"
}

function check_post {
  
  sqlite3 "$DBFILE" "SELECT type FROM posts WHERE id='$1'"
}

function check_forum {
  
  sqlite3 "$DBFILE" "SELECT id FROM forums WHERE id='$1'"
}

function get_gparent {

  make_number $(sqlite3 "$DBFILE" "SELECT globalparent FROM posts WHERE id='$1'")
}

function get_post_vars {
#function will get all information about post

  #avaiable rows are:
  # (id, title, body, type, globalparent, parent, data)
  
  if [ -n $(make_number $1) ]; then

    body=$(sqlite3 "$DBFILE" "SELECT body FROM posts WHERE id='$post_id'" | sed -e 's/\[br\]/\<br\>/g')
    title=$(sqlite3 "$DBFILE" "SELECT title FROM posts WHERE id='$post_id'" | sed -e 's/\[br\]//g')
    parent=$(make_number $(sqlite3 "$DBFILE" "SELECT parent FROM posts WHERE id='$post_id'"))
    type=$(sqlite3 "$DBFILE" "SELECT type FROM posts WHERE id='$post_id'")
  
    if [ -n "$parent" ] && [ "$type" == 'post' ]; then

      parent_author=$(sqlite3 "$DBFILE" "SELECT author FROM posts WHERE id='$parent'")
      parent_date=$(get_time_string $(sqlite3 "$DBFILE" "SELECT data FROM posts WHERE id='$parent'"))
      parent_type=$(sqlite3 "$DBFILE" "SELECT type FROM posts WHERE id='$parent'")
    fi

    if [ "$type" == "deleted_post" ] || [ "$type" == "deleted_thread" ]; then

      dreason=$(sqlite3 "$DBFILE" "SELECT dreason FROM posts WHERE id='$post_id'")
      dauthor=$(sqlite3 "$DBFILE" "SELECT dauthor FROM posts WHERE id='$post_id'")
    fi

    author=$(sqlite3 "$DBFILE" "SELECT author FROM posts WHERE id='$post_id'")
    date=$(get_time_string $(sqlite3 "$DBFILE" "SELECT data FROM posts WHERE id='$post_id'"))
    
    #that's all, heh
  fi
}

function get_parent_info {
  
  parent_type=$(sqlite3 "$DBFILE" "SELECT type FROM posts WHERE id='$parent'")
  parent_author=$(sqlite3 "$DBFILE" "SELECT author FROM posts WHERE id='$parent'")
  parent_date=$(get_time_string $(sqlite3 "$DBFILE" "SELECT data FROM posts WHERE id='$parent'"))
  
}

function get_user_vars {

  id=$(get_user_param 'id' $1)
  userinfo=$(get_user_param 'userinfo' $1)
  reg=$(get_user_param 'reg' $1)
  score=$(get_user_param 'score' $1)
  u_state=$(get_user_param 'state' $1)
}

function get_user_param {

  sqlite3 "$DBFILE" "SELECT $1 FROM users WHERE nick='$2'"  
}

function insert_post {

  local body="$1"
  local title="$2"
  local parent="$3"
  local globalparent="$4"
  local type="$5"
  local date="$(get_time)"
  local author="$nick"

  vals='(body, title, parent, globalparent, type, data, author)'
  set="('$body', '$title', '$parent', '$globalparent', '$type', '$date', '$author')"

  sqlite3 "$DBFILE" "INSERT INTO posts $vals VALUES $set"
}

function get_last_postid {
  sqlite3 "$DBFILE" "SELECT id FROM posts ORDER BY id desc LIMIT 1"
}
