#!/bin/bash

#api/html.sh

function get_userlink {
#just return user-link
  
  if [ -n "$1" ]; then
    state=$(get_user_param 'state' "$1")
    if [ "$state" != 'banned' ]; then
      echo "<a href=\"profile.sh?nick=$1\">$1</a>"
    else
      echo "<strike><a href=\"profile.sh?nick=$1\">$1</a></strike>"
    fi
  fi
}

function get_welcome {
  echo '<div id="loginGreating" class="head">'
  if [ "$nick" == 'anonymous' ]; then
    echo 'Hello, <b>anonymous</b> [<a href="login.sh">Log in</a>]'
  else
    link=$(get_userlink $nick)
    echo "Hello, <b>$link</b> [<a href=\"exit.sh\">x</a>]"
  fi
  echo '</div>'
}

function page_html {

#should write header or footer
# $1 - mode (header/footer/some form)
# $2 - title for header mode

  if [ "$1" == 'header' ]; then
    local title
    title="$TITLE"
    if [ -n "$2" ]; then
      title="$title: $2"
    fi
    
    cat 'html/header.html' | sed -e "s/@@TITLE@@/$title/"
    echo '<div id="doc3" class="yui-t5">'
    echo '<div id=hd>'
    get_welcome
    echo "<h1><a id=\"sitetitle\" href=\"/\">$SITENAME</a></h1>"
    echo '</div>'
  elif [ "$1" == 'footer' ]; then
    echo '</div>'
    cat 'html/footer.html'
  elif [ "$1" == 'post' ]; then

    local post_html
    post_html=$(cat 'html/post.html')

    body=$( echo -e "$body" | sed -e 's/\n/<br>/g' )
  
    post_html="${post_html//"'POST-ID'"/$post_id}"
    post_html="${post_html//"'ANSWER'"/$answer}"
    post_html="${post_html//"'TITLE'"/$title}"
    post_html="${post_html//"'BODY'"/$body}"
    post_html="${post_html//"'AUTHOR-LINK'"/$author_link}"
    post_html="${post_html//"'DATE'"/$date}"


  
    echo -e "$post_html"
  elif [ "$1" == 'postform' ]; then
   
    local post_html
    post_html=$(cat 'html/postform.html')

    post_html="${post_html//"'REPLY-TO'"/$2}"
    post_html="${post_html//"'MODE'"/$3}"

    
    post_html="${post_html//"'TITLE'"/$4}"
    post_html="${post_html//"'BODY'"/$5}"

    echo -e "$post_html"
  else
    cat "$(make_safe html/$1.html)" #i'm paranoic, sorry
  fi

}

function fail_operation {

    source 'api/header.sh'
    page_html 'header' 'failed'
    echo "<b>failed $1</b>"
    page_html 'footer'
    exit
}

