#!/bin/bash
for r in ${routers[@]};
do
for t in ${adress[@]}; 
do
sudo ip netns exec $r ping6 $t -c25 >> Rapport_Securite_Test
done
done

#sudo ./connect_to.sh automatetest_cfg P1 && 
#ping6 fde4:9::1111 -c5  > /dev/null

