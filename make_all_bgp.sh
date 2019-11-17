#!/bin/bash
FILES=json_bgp/*
for f in $FILES.*
do
  echo "Processing ${f%%.*} file..."
  # take action on each file. $f store current file name
  sudo ./make_bgp_conf.py -t bgp.mako -i $f -o ${f%%.*}.conf    
  
done
