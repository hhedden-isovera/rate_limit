#!/bin/bash

URL='https://api.github.com/rate_limit'
AUTH=false

while getopts 'u:' OPTION; do
  case $OPTION in
    u) USR=$OPTARG
       read -sp "GitHub password: " PASS
       AUTH=true
       echo
       ;;
    ?) echo "Usage: ${0##*/} [-u [username]]" >&2
       exit 2
       ;;
  esac
done

if $AUTH; then
  data=$(curl -su $USR:$PASS $URL | jq '.resources | {core, search}')
else
  data=$(curl -s $URL | jq '.resources | {core, search}')
fi

echo $data | jq '.core.reset |= todate | .search.reset |= todate'

