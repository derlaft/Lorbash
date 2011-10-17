#!/bin/bash

#addpost.sh

#isn't ready yet

source 'api/core.sh'

replyto=$(make_number $(param replyto) )

body=$(param body)
title=$(param title)
mode=$(param mode)

if [ -n "$(param 'preview')" ]; then

  source 'api/header.sh'
  page_html 'header' 'Предпросмотр сообщения'
  echo "<div class=messages>"
  if [ "$mode" == 'post' ]; then
    get_post "$replyto"
  fi
  make_post "$body" "$title" "$replyto" "$mode" "$nick"
  page_html 'postform' "$replyto" "$mode" "$title" "$body"
  echo "</div>"
  page_html 'footer'

elif [ -n "$mode" ] && [ -n "$replyto" ] && [ -z "$body" ]; then

  source 'api/header.sh'
  page_html 'header' 'Добавить сообщение'
  page_html 'postform' "$replyto" "$mode"
  page_html 'footer'

elif [ -n "$mode" ] && [ -n "$replyto" ] && [ -n "$body" ]; then

  r=$(make_post_byparams "$body" "$title" "$replyto" "$mode")
  if [ "$r" == 'ok' ]; then
    source 'api/redirect.sh' "/gopost.sh?id=$(get_last_postid)"
  else
    source 'api/header.sh'
    echo "mode:'$mode',replyto:'$replyto',parent:'$parent'"
  fi
fi
