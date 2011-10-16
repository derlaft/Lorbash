#!/bin/bash

#api/post.sh

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
  local author
  
  #first, let's get and id
  post_id=$(make_number $1)
  
  #and check it
  if [ -z "$post_id" ]; then
    echo 'invalid post'
    return
  fi
  
  get_post_vars "$post_id"
  
  if [ -z "$body" ] && [ -z "$title" ]; then
    echo 'invalid post'
    return
  fi

  if [ "$type" == "post" ] && [ -n "$parent" ]; then
    answer="Ответ на <a href=\"gopost.sh?id=$parent\">комментарий</a> $parent_author от $parent_date"
  fi

  if [ "$type" == "deleted_post" ] || [ "$type" == "deleted_thread" ]; then
    answer="<b>Сообщение удалено $dauthor по причине '$dreason'</b> $answer"
  fi
  
  author_link=$(get_userlink "$author")

  page_html 'post'

}

function make_post {

  local body="$1"
  local title="$2"
  local parent="$3"
  local type="$4"
  local parent_author
  local parent_date
  local answer
  local date=$(get_time_string $(get_time) )
  local author="$5"

  get_post_params

  page_html 'post'

}

function get_post_params {
  
  if [ -z "$body" ] && [ -z "$title" ]; then
    echo 'invalid post'
    return
  fi

  if [ "$type" == "post" ] && [ -n "$parent" ] && [ "$globalparent" != "$parent" ]; then
    answer="Ответ на <a href=\"gopost.sh?id=$parent\">комментарий</a> $parent_author от $parent_date"
  fi

  author_link=$(get_userlink "$author")
}



function make_post_byparams {

  local body=$(make_safe "$1")
  local title=$(make_safe "$2")
  local parent=$(make_number "$3")
  local type=$(make_safe "$4")
  local author="$nick"
  
  #parent and globalparent
  local globalparent

  globalparent=$( get_gparent "$parent" "$type" "$parent" )
  
  if [ "$type" == 'post' ] && [ -z "$(check_post $globalparent)" ] || \
     [ "$type" == 'thread' ] && [ -z "$(check_forum $globalparent)" ]; then 
       echo '403'
  else
    insert_post "$body" "$title" "$parent" "$globalparent" "$type"
  fi
}

function detect_gparent {
  if [ "$1" == 'post' ]; then
    globalparent=$(get_gparent "$1")
  fi
}
