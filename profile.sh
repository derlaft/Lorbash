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
  echo "<b>no such user</b>"
  exit
fi

echo "<b>User-ID</b>: $id<br>"
echo "<b>Nickname</b>: $nickname<br>"

u_state=$(get_user_param 'state' $nick)
if [ "$nick" == "$nickname" ] || [ "$u_state" == 'moderator' ] && [ "$nick" != 'anonymous' ] ; then
  echo "<b>Score</b>: $score<br>"
fi

if [ -n "$userinfo" ]; then
  echo "<b>User-Info</b>:"
  echo "<p>$userinfo</p>"
fi

if [ -n "$reg" ]; then
  echo "<b>Reg-Date</b>: $(get_time_string $reg)<br>"
fi

cat 'html/footer.html'

#so..
