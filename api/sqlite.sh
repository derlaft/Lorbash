#!/bin/bash

#api/sqlite.sh

# database filename
DBFILE="db/forum.db"

# function makes query to database
function make_array {
  echo $* | sed -e 's/|/ /g'
}

function make_number {
  echo $* | sed -e 's/[^ 0-9]//g'
}

function get_time {
  date +%s
}

function get_time_string {
  date -d "@$@" +"%H:%M:%S %D"
}
