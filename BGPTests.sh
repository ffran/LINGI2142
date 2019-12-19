#!/bin/bash
adress=(fde4:9::1111 fde4:9::22 fde4:9::33)  
routers=("P11 P1 P2")  
for r in ${routers[@]}; do
  sudo ./connect_to.sh ./automatetest_cfg/ $r << 'EOF'
  LD_LIBRARY_PATH=/usr/local/lib vtysh
  show bgp summary
EOF
