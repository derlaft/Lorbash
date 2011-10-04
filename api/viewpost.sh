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
    if [ "$2" == "with_deleted" ]; then

      answer="<b>Сообщение удалено $dauthor по причине '$dreason'</b> $answer"
    fi
  fi
  
  author_link=$(get_userlink "$author")

  #let's prepare fields:
  #Replace separator
  
  answer=$(echo "$answer" |  sed -e 's/|/&separator/g;s/\;/&cp/g')
  title=$(echo "$title" |  sed -e 's/|/&separator/g;s/\;/&cp/g')
  body=$(echo "$body" | sed -e 's/|/&separator/g;s/\;/&cp/g')
  date=$(echo "$date" | sed -e 's/|/&separator/g;s/\;/&cp/g')
  
  #final replace
  cat 'html/post.html' | sed -e "s|'POST-ID'|$post_id|g;s|'ANSWER'|$answer|g;s|'TITLE'|$title|g" | \
                       sed -e "s|'BODY'|$body|g;s|'AUTHOR-LINK'|$author_link|g;s|'DATE'|$date|g" | \
                                                            sed -e 's/&separator/|/g;s/&cp/\;/g'
}


