#!/bin/bash
adress=(fde4:9::1111 fde4:9::22 fde4:9::33)
routers=(P11 P1 P2 P3)
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

