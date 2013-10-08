#!/bin/bash

# DBpedia release to use
readonly DBPEDIA_VERSION='3.9'

curl -O http://downloads.dbpedia.org/${DBPEDIA_VERSION}/en/instance_types_en.ttl.bz2
curl -O http://downloads.dbpedia.org/${DBPEDIA_VERSION}/en/page_links_en.ttl.bz2
