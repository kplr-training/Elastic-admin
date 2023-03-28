#!/bin/sh
for file in *.ndjson; do
  curl -XPOST -k -u elastic:kplr123 'https://esnode-1.elastic.kplr.fr:9200/wikitest/_bulk' \
  -H 'Content-Type: application/json' \
  --data-binary "@$file"  > ingest.log
done
