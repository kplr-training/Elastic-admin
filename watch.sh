#!/bin/sh
watch -n 1 'curl -s -X GET -k -u elastic:kplr123 "https://esnode-1.elastic.kplr.fr:9200/_cat/indices" | awk -v OFS="\t" "{print \$3, \$7, \$9}"'
