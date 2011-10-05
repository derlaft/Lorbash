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
  echo "$@" | sed -e 's/</&lt\;/g;s/>/&gt\;/g;s/&/&amp\;/g;s/-/&ndash\;/g' 
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
    date=$(get_time_string $(sqlite3 "$DBFILE" "SELECT data FROM posts WHERE id='$post_id'"))
    
    #that's all, heh
  fi
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

function can_post {

#usage:
# post type
# parent id
# sender score


  if [ "$1" == 'thread' ]; then
    local checked_id
    local min_score
    local score
    local state

    checked_id=$(sqlite3 "$DBFILE" "SELECT id FROM forums WHERE id='$2'")
    min_score=$(sqlite3 "$DBFILE" "SELECT minscore FROM forums WHERE id='$2'")
    score=$(get_user_param 'score' $3)
    state=$(get_user_param 'state' $3)

    if [ "$checked_id" == "$2" ]; then
      if [ -n "$min_score" ]; then
        if (( "$min_score" >= "$score" )) || [ "$state" == "moderator" ]; then
          echo 'yes'
        else
          echo 'no'
        fi
      else
        echo 'yes'
      fi
    else
      echo 'no'    
    fi
  elif [ "$1" == 'post' ]; then
    can_post 'thread' $(get_gparent "$2") "$3"
  fi
}

function insert_post {
#params:
# title, body, tags, date, author, type, globalparent, parent

  rows='(title, body, tags, data, author, type, globalparent, parent)'
  values="('$1', '$2', '$3', '$4', '$5', '$6', '$7', '$8')"

  sqlite3 "$DBFILE" "insert into posts $rows values $values"

#we did it!

}
