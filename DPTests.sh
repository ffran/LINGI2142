#!/bin/bash
adress=(fde4:9::1111 fde4:9::22 fde4:9::33)  
routers=("P11")  
for r in ${routers[@]}; do
  for t in ${adress[@]}; do
    sudo ip netns exec $r ping6 $t -c5  
    sudo ip netns exec $r show bgp summary
    sudo ./connect_to.sh ./automatetest_cfg/ $r << 'EOF'
    LD_LIBRARY_PATH=/usr/local/lib vtysh
    show bgp summary
EOF
    if [$? -eq 0];
    then
      echo "ok"
    else 
      echo "Problème à l'adresse $t depuis le routeur $r"
    fi
  done
done

#sudo ./connect_to.sh automatetest_cfg P1 && 
#ping6 fde4:9::1111 -c5  > /dev/null

