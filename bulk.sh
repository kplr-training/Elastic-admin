#!/bin/sh

if [ -z "$1" ]
  then
    echo "No index name argument supplied"
    exit 1
fi

if [ -z "$2" ]
  then
    echo "No number of files argument supplied"
    exit 1
fi

counter=0

for file in *.ndjson; do
  if [ "$counter" -ge "$2" ]
    then
      break
  fi

  curl -XPOST -k -u elastic:kplr123 "https://esnode-1.elastic.kplr.fr:9200/$1/_bulk" \
  -H "Content-Type: application/json" \
  --data-binary "@$file" > ingest.log
  #sleep 10s

  counter=$((counter+1))
done
