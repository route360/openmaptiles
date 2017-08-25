#!/bin/bash

re='^-?[0-9]+([.][0-9]+)?$'

if [ "$#" -ne 5 ] && ![[$2 =~ re]] && [![$3 =~ re]] && [![$4 =~ re]] && [![$5 =~ re]] 
then
  echo "Usage: \n
  ./custom-region-prep.sh export_name(STRING) min_lng(NUMEBR) min_lat(NUMEBR) max_lng(NUMEBR) max_lat(NUMEBR)\n
  E.g. ./custom-region-prep.sh oslo_norway 9.691 58.938 11.493 60.424
  "
  exit 1
fi

export area_name=$1
export min_lng=$2
export min_lat=$3
export max_lng=$4
export max_lat=$5
export timestamp=$( date --utc +%FT%TZ )

# get env variables from file
while read line; do
  export $line
done <.env

sudo cat >data/docker-compose-config.yml <<EOF
version: "2"
services:
  generate-vectortiles:
    environment:
      BBOX: " ${min_lng}, ${min_lat}, ${max_lng}, ${max_lat}"
      OSM_MAX_TIMESTAMP : "${timestamp}"
      OSM_AREA_NAME: "${area_name}"
      MIN_ZOOM: "${QUICKSTART_MIN_ZOOM}"
      MAX_ZOOM: "${QUICKSTART_MAX_ZOOM}"
EOF

