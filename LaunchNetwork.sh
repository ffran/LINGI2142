#!/bin/bash
sudo ./cleanup.sh
if [ -d "automatetest_cfg" ]; then
	cd automatetest_cfg/
	sudo rm -r *
	cd ..
fi
#echo ${ls automatest_cfg}
sudo ./create_network.sh automatetest_conf
sudo ./cleanup.sh
sudo ./launch_all.py
sudo ./make_all_bgp.sh
sudo ./create_network.sh automatetest_conf
