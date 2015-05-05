#!/bin/bash


for n in {0..9}
do
  xsltproc elink-json.xslt sample-$n.xml > sample-$n.json
done
