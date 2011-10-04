#!/bin/bash

#login.sh

source 'api/core.sh'

mode=$(param a)
if [ -z "$mode" ]; then
  source 'api/header.sh'
  page_html 'header' 'login'
  page_html 'login'
  page_html 'footer'
  exit
fi
if [ "$nick" == "anonymous" ]; then
  post_user=$(param nick)
  post_passwd=$(param passwd)
  passwd=$(get_password $post_user)
  state=$(get_state $post_user)
  if [ "$passwd" == "$post_passwd" ] && [ "$state" != 'banned' ]; then
    newsid=$(random_seed)
    source 'api/redirect.sh' 'index.sh' "nick=$post_user" "sid=$newsid"
    sqlite3 "$DBFILE" "UPDATE users SET sid='$newsid' WHERE nick='$post_user'"
    nick=$post_user
  else
    source 'api/header.sh'
    page_html 'header' 'login'
    echo '<b>403</b>'
    page_html 'footer'
  fi
else
  source 'api/redirect.sh' 'index.sh'
fi
