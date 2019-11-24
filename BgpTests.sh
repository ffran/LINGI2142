#!/bin/bash
myfunc () {
adress=(fde4:9::1111 fde4:9::22 fde4:9::33)
routers=("P1 P11")
for r in ${routers[@]}; do
  sudo ./connect_to.sh ./automatetest_cfg/ $r << 'EOF' 
  LD_LIBRARY_PATH=/usr/local/lib vtysh
  echo @@@@@
  show bgp summary json
EOF
done
sudo python3 testFileAnalyse.py
}
myfunc >> essai.txt

