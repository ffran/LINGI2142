#!/bin/bash
adress=(fde4:9::1111 fde4:9::22 fde4:9::33 fde4:9::11 fde4:9::33 fde4:9::44 fde4:9::55 fde4:9::99 fde4:9:1111::9191 fde4:9:1111::9292 fde4:9::1111 fde4:9::1010)
routers=(P1 P2 P3 P4 P5 P9 P91 P92 P10 P11)
sudo rm Rapport_Test_OSPF.txt
number=$RANDOM
randomRouter=${routers[$RANDOM % ${#routers[@]} ]}
sudo ip netns exec $randomRouter sudo ip link set lo down
for r in ${routers[@]};
do
for t in ${adress[@]}; 
do
sudo ip netns exec $r ping6 $t -c5 > /dev/null
if [ "${?}" -ne 0 ]; then
echo "No connection from ${r} to ${t}" >> Rapport_Test_OSPF.txt
echo "Traceroute6 result from ${r} to ${t} :" >> Rapport_Test_OSPF.txt
sudo ip netns exec $r traceroute6 $t >> Rapport_Test_OSPF.txt
else
echo "Valid connection from ${r} to ${t}" >> Rapport_Test_OSPF.txt
fi  
done
done
sudo ip netns exec $randomRouter sudo ip link set lo up
#sudo ./connect_to.sh automatetest_cfg P1 && 
#ping6 fde4:9::1111 -c5  > /dev/null

