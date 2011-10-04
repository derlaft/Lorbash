#!/bin/bash

#api/redirect.sh

echo "Content-Type: text/html"
echo "Location: $1"

if [ $# -gt 1 ]; then
  for i in $@
  do
    if [ "$i" == "$1"]; then
      continue
    fi
    echo "Set-Cookie: $i"
  done
fi
echo
