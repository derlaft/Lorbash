#!/bin/bash

#addpost.sh

#isn't ready yet

source 'api/core.sh' 'header'

page_html 'header'

mode=$(param mode)

if [ -z "$mode" ]; then
  page_html 'addpost'
  page_html 'footer'
fi

parent=$(make_number $(param replyto))

if [ "$mode" == 'thread' ]; then

  globalparent="$parent"
  parent=''

elif [ "$mode" == 'post' ]; then 

  ptype=$(check_post $parent)

  if [ "$ptype" == 'post' ]; then
    globalparent=$(get_gparent $parent
  elif [ "$ptype" == 'thread' ] ; then
    globalparent="$parent"
    #we dont need parent here
    parent=''
  else
    page_html 'header' 'failed'
    echo '<b>failed</b>'
    page_html 'footer'
    return
  fi

fi

#no tag support yet

title=$(make_safe $(param title))
body=$(make_safe $(param body))
date=$(get_time) 


