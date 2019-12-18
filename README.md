# LINGI2142 - ISP network - Team 9
## This repository contain
* [automatest_cfg] a directory with all config file of our network
* [json_bgp] a directory with all json files for the bgp configuration
* [firewall] a directoy with all firewall configuration,a mako to generate this files and a subdirectory json for the mako
* [automatetest_conf] : a file with the configuration of our network
* [bgp6d.mako, start.mako, zebra.mako, ospf6d.mako ] : Mako files to make the the configuration files (the files in the automatetest.cfg)
* [make_all_bgp.sh, make_bgp_conf.py, make_router_conf.py] : Just script used by the automatisation
* [launch_all.py] : file used to generate the start files, zebra files and ospf files
* [LaunchNetwork.sh] : file to run or update and restart our network

## How to run our network
* Execute the script ./LaunchNetwork.sh
* This script will first clean you last network.
* He will update the files in the configuration file in the directory automatetest_cfg (Warning : you must have a directory with this name else the script will not working)
* He will run your network with the new file configuration

## How to modify our network 
### Modify BGP
* Change the data in the json in the json_bgp directory
* If you want add a new option add it on each json file and update also the mako
* If you add a new router create a new bgp json file
### Modify OSPF
* If you want to add a router, change data just change it in the launch_all.py file (no json file)
### New topology
* If the topology change you must also update it in the automatest_conf
