#!/bin/bash

#addpost.sh

#isn't ready yet

source 'api/core.sh'

mode=$(param mode)
parent=$(make_number $(param replyto))

if [ "$mode" == 'thread' ]; then

  globalparent="$parent"
  parent=''
  tags=$(make_safe $(param tags))

elif [ "$mode" == 'post' ]; then 

  ptype=$(check_post $parent)

  if [ "$ptype" == 'post' ]; then
    globalparent=$(get_gparent $parent)
  elif [ "$ptype" == 'thread' ] ; then
    globalparent="$parent"
    #we dont need parent here
    parent=''
  else
    fail_addpost
  fi

fi

title=$(make_safe $(param title))
body=$(make_safe $(param body))
date=$(get_time) 

order=$(can_post "$mode" "$globalparent" "$nick")

if [ "$order" == 'yes' ]; then
  newid=$(insert_post "$title" "$body" "$tags" "$date" "$nick" "$mode" "$globalparent" "$parent")
  source 'api/redirect.sh' "gopost.sh?id=$newid"
else
  fail_addpost
fi

function fail_addpost {
    page_html 'header' 'failed'
    echo '<b>failed</b>'
    page_html 'footer'
    exit
}

