#!/bin/bash
# My first script

sudo ip netns exec P1 ping6 fde4:9::1111 -c5 
sudo ip netns exec P3 ping6 fde4:9::1111 -c5
#sudo ./connect_to.sh automatetest_cfg P1 && 
#ping6 fde4:9::1111 -c5  > /dev/null
if [ $? -eq 0 ]
then
	echo "ok"
else 
	echo "Problème à l'adresse fde4:9::1111"
fi
