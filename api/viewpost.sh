#!/bin/bash

#viewpost.sh

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


