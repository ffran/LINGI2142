#!/bin/bash

adress=(fde4:9::1111)
routers=("P1" "P2" "P3")
#sudo ip netns exec P1 ping6 fde4:9::1111 -c5 
#sudo ip netns exec P3 ping6 fde4:9::1111 -c5
for t in ${adress[@]}; do
  sudo ip netns exec P1 ping6 fde4:9::1111 -c5 $t
done
#sudo ./connect_to.sh automatetest_cfg P1 && 
#ping6 fde4:9::1111 -c5  > /dev/null
if [ $? -eq 0 ]
then
	echo "ok"
else 
	echo "Problème à l'adresse fde4:9::1111"
fi
