#!/bin/bash

#addpost.sh

#isn't ready yet

source 'api/core.sh' 'header'

mode=$(param mode)

page_html 'header'

if [ -z "$mode" ]; then
  page_html 'addpost'
  page_html 'footer'
else

  parent=$(param replyto)  

  ptype=$(check_post $parent)

  if [ "$ptype" == 'post' ]; then
    globalparent=$(get_gparent $parent)
  elif [ "$ptype" == 'thread' ]; then
    globalparent="$parent"
  else
    page_html 'header' 'failed'
    echo '<b>failed</b>'
    page_html 'footer'
    return
  fi

  title=$(param title)
  body=$(param body)
  date=$(get_time) 

fi
