#!/bin/bash
adress=(fde4:9::1111 fde4:9::22 fde4:9::33)
routers=(P11 P1 P2 P3)
for r in ${routers[@]};
do
sudo ./connect_to.sh ./automatetest_cfg/ $r << 'EOF'
LD_LIBRARY_PATH=/usr/local/lib vtysh
show bgp summary
EOF
for t in ${adress[@]}; 
do
sudo ip netns exec $r ping6 $t -c5
done
done

#sudo ./connect_to.sh automatetest_cfg P1 && 
#ping6 fde4:9::1111 -c5  > /dev/null

