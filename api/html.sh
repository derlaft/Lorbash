#!/bin/bash

#api/html.sh

function get_userlink {
#just return user-link
  
  if [ -n "$1" ]; then
    state=$(get_user_state "$1")
    if [ "$state" != 'banned' ]; then
      echo "<a href=\"profile.sh?nick=$1\">$1</a>"
    else
      echo "<strike><a href=\"profile.sh?nick=$1\">$1</a></strike>"
    fi
  fi
}

function get_welcome {
  
  if [ "user" == 'anonymous' ]; then
    echo 'Hello, <b>anonymous</b>'
  else
    link=$(get_userlink)
    echo "Hello, <b>$link</b>"
  fi
}

function page_html {

#should write header or footer
# $1 - mode (header/footer/some form)
# $2 - title for header mode

if [ "$1" == 'header' ]; then
  if [ -z "$2" ]; then
    title="$TITLE"
  else
    title="$TITLE: $2"
  fi
  cat 'html/header.html' | sed -e "s/@@TITLE@@/$title/"
elif [ "$1" == 'footer' ]; then

  cat 'html/footer.html'
elif [ "$1" == 'addpost' ]; then

  cat 'html/addpost.html'
elif [ "$1" == 'login' ]; then

  cat 'html/login.html'
fi

}
