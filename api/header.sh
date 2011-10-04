#!/bin/bash

#api/header.sh

echo "Content-Type: text/html"

if [ $# -gt 0 ]; then
  for i in $@
  do
    echo "Set-Cookie: $i"
  done
fi
echo
