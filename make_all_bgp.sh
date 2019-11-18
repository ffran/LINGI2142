#!/bin/bash
FILES=json_bgp/*



for f in $FILES.*
do

 echo ${f##*/}
a=${f##*/}
 echo ${a%.txt}

a= echo ${a%.*}

  echo "Processing $a file..."

   initial="$(echo ${a%.*} | head -c 3 | tail -c 2)"
  echo "$initial"
  # take action on each file. $f store current file name
  sudo ./make_bgp_conf.py -t bgp6d.mako -i $f -o automatetest_cfg/${a%.*}/"p$initial"_bgp_test.conf    

done
