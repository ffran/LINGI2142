#!/bin/bash
FILES=json/*



for f in $FILES.*
do

 echo ${f##*/}
a=${f##*/}
 echo ${a%.txt}

a= echo ${a%.*}

  echo "Processing $a file..."
  # take action on each file. $f store current file name
  sudo ./make_firewall_sh.py -t firewall.mako -i $f -o "${a%.*}".sh    
  chmod 777 "${a%.*}".sh

done
