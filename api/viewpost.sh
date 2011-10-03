#!/bin/bash

#viewpost.sh

source 'api/sqlite.sh'

function get_post {

  local post_id
  local body
  local title 
  local parent
  local type
  local parent_author
  local parent_date
  local answer
  local dreason
  local dauthor
  local date

  #avaiable rows are:
  # (id, title, body, type, globalparent, parent, data)
  
  #first, let's get and id
  post_id=$(make_number $1)
  
  #and check it
  if [ -z "$post_id" ]; then
    echo 'invalid post'
    exit
  fi
  
  #now, we can get post body and title
  body=$(sqlite3 "$DBFILE" "SELECT body FROM posts WHERE id='$post_id'")
  title=$(sqlite3 "$DBFILE" "SELECT title FROM posts WHERE id='$post_id'")

  if [ -z "$body" ] && [ -z "$title" ]; then
    echo 'invalid post'
    exit
  fi

  #and parents
  parent=$(make_number $(sqlite3 "$DBFILE" "SELECT parent FROM posts WHERE id='$post_id'"))
  type=$(sqlite3 "$DBFILE" "SELECT type FROM posts WHERE id='$post_id'")

  if [ "$type" == "post" ]; then
    if [ -n "$parent" ]; then
      parent_author=$(sqlite3 "$DBFILE" "SELECT author FROM posts WHERE id='$parent'")
      parent_date=$(get_time_string "$(sqlite3 "$DBFILE" "SELECT date FROM posts WHERE id='$parent'")")
      answer="Ответ на <a href=\"gopost.sh?id=$parent\"</a>комментарий $parent_author от $parent_date"
    fi
  fi

  if [ "$type" == "deleted" ]; then
    if [ "$2" == "with_deleted" ]; then
      dreason=$(sqlite3 "$DBFILE" "SELECT dreason FROM posts WHERE id='$post_id'")
      dauthor=$(sqlite3 "$DBFILE" "SELECT dauthor FROM posts WHERE id='$post_id'")
      answer="<b>Сообщение удалено $dauthor по причине '$dreason'</b> $answer"
    fi
  fi

  #author and date
  author=$(sqlite3 "$DBFILE" "SELECT author FROM posts WHERE id='$post_id'")
  date=$(sqlite3 "$DBFILE" "SELECT date FROM posts WHERE id='$post_id'")
  date=$(get_time_string "$date")
  
  #let's prepare fields

  #Replace separator
  
  answer=$(echo "$answer" |  sed -e 's/|/&separator/g')
  title=$(echo "$title" |  sed -e 's/|/&separator/g')
  body=$(echo "$body" | sed -e 's/|/&separator/g')
  date=$(echo "$date" | sed -e 's/|/&separator/g')
  
  #final replace
  cat 'html/post.html' | sed -e "s|'POST-ID'|$post_id|g" | \
                         sed -e "s|'ANSWER'|$answer|g" | \
                         sed -e "s|'TITLE'|$title|g" | \
                         sed -e "s|'BODY'|$body|g" | \
                         sed -e "s|'AUTHOR'|$author|g" | \
                         sed -e "s|'DATE'|date|g" | \
                         sed -e 's/&separator/|/g'
  #echo 1
}
