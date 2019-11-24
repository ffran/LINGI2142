ldconfig
#!/bin/bash


ip link set dev lo up
ip -6 addr add ${data['loopback_adress']} dev lo

%for link in data['interfaces']:
ip link set dev ${data['hostname']}-${link['name']} up
ip -6 addr add ${link['adress']} dev ${data['hostname']}-${link['name']}
%endfor 

%for link in data['bgpInterface']:
ip link set dev ${link['name']} up
ip -6 addr add ${link['adress']} dev ${link['name']}
%endfor

# zebra is required to make the link between all FRRouting daemons
# and the linux kernel routing table
LD_LIBRARY_PATH=/usr/local/lib /usr/lib/frr/zebra -A 127.0.0.1 -f /etc/zebra.conf -z /tmp/${data['hostname2']}.api -i /tmp/${data['hostname2']}_zebra.pid &
# launching FRRouting OSPF daemon
LD_LIBRARY_PATH=/usr/local/lib /usr/lib/frr/ospf6d -f /etc/${data['hostname2']}_ospf.conf -z /tmp/${data['hostname2']}.api -i /tmp/${data['hostname2']}_ospf6d.pid -A 127.0.0.1 &
#bgp
LD_LIBRARY_PATH=/usr/local/lib /usr/lib/frr/bgpd -f /etc/${data['hostname2']}_bgp.conf -z /tmp/${data['hostname2']}.api -i /tmp/${data['hostname2']}_bgpd.pid -A 127.0.0.1
