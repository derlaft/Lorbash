#!/bin/bash

#profile.sh

source 'api/header.sh'
source 'api/bashlib.sh'
source 'api/sqlite.sh'
source 'api/login.sh'

#we just need to write all profile info
#at first, lets get user ID
#avaiable rows are:
# id, nick, passwd, state, sid, posts, score, userinfo, reg

nickname=$(param nick)
cat 'html/header.html' | sed -e "s/@@TITLE@@/$nickname\'s profile/"
id=$(sqlite3 "$DBFILE" "SELECT id FROM users WHERE nick='$nickname'")

if [ -z $id ]; then
  echo "<p>no such user</p>"
  exit
fi

echo "User-ID: $id<br>"
echo "Nickname: $nickname<br>"

userinfo=$(sqlite3 "$DBFILE" "SELECT userinfo FROM users WHERE nick='$nickname'")
reg=$(sqlite3 "$DBFILE" "SELECT reg FROM users WHERE nick='$nickname'")

if [ -n "$userinfo" ]; then
  echo "User-Info:"
  echo "<p>$userinfo</p>"
fi

if [ -n "$reg" ]; then
  echo "Reg-Date: $reg<br>"
fi

cat 'html/footer.html'
