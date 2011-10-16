#!/bin/bash

#core.sh

source 'api/config.sh'
source 'api/bashlib.sh'
source 'api/sqlite.sh'
source 'api/login.sh'
source 'api/html.sh'
source 'api/post.sh'

[ "$1" == "header" ] && source 'api/header.sh'
