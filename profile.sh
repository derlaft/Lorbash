#!/bin/bash

#profile.sh

source 'api/core.sh' 'header'

#we just need to write all profile info
#at first, lets get user ID
#avaiable rows are:
# id, nick, passwd, state, sid, posts, score, userinfo, reg

nickname=$(param nick)

page_html 'header' "$nickname\'s profile"

get_user_vars "$nickname"

if [ -z $id ]; then
  echo "<p>no such user</p>"
  exit
fi

echo "User-ID: $id<br>"
echo "Nickname: $nickname<br>"

if [ -n "$userinfo" ]; then
  echo "User-Info:"
  echo "<p>$userinfo</p>"
fi

if [ -n "$reg" ]; then
  echo "Reg-Date: $(get_time_string $reg)<br>"
fi

cat 'html/footer.html'
