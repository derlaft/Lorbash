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
  make_post "$body" "$title" "$replyto" "$mode" "$nick"
  echo "</div>"
  page_html 'footer'
elif [ -n "$mode" ] && [ -n "$replyto" ] && [ -z "$body" ]; then
  source 'api/header.sh'
  page_html 'header' 'Добавить сообщение'
  page_html 'postform' "$replyto" "$mode"
  page_html 'footer'
elif [ -n "$mode" ] && [ -n "$replyto" ] && [ -n "$body" ]; then
  source 'api/header.sh'
  page_html 'header' 'Добавлено'
  make_post_byparams "$body" "$title" "$replyto" "$mode"
  page_html 'footer'
fi
