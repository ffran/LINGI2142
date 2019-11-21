#!/bin/bash
routers=("P11")
for r in ${routers[@]}; do
  sudo ./connect_to.sh ./automatetest_cfg/ P11 << 'EOF'
  LD_LIBRARY_PATH=/usr/local/lib vtysh
  show bgp summary
EOF
done
