#!/usr/bin/env python3
import json
import copy
import make_router_conf as mf
import os
from mako.template import Template
import shutil



#TODO : gérer les cas ou le numero du routeur est > 10 (passage en hexadecimal) + automatiser create_network
def main():
	#router = [("P1",1),("P2",2),("P3",3),("P4",4),("P5",5),("P6",6),("P7", 7),("P8",8),("P9",9)]
	    add_link P1 P2
    # P1-eth1 links to P3-eth0
    add_link P1 P3
    add_link P2 P8
    add_link P2 P9
    add_link P2 P4
    add_link P3 P5
    add_link P3 P7
    add_link P4 P8
    add_link P4 P6
    add_link P4 P10
    add_link P5 P6
    add_link P5 P7
    add_link P5 P10
    add_link P3 P9

	router = [("P1",1),("P2",2),("P3",3),("P4",4),("P5",5),("P6",6),("P7",7),("P8",8),("P9",9),("P10",10)]
	bgpLinks = [("P1", "P2", 2, 1),("P2", "P3", 3, 2)]
	links = [("P1","P3",3,1),("P2","P8",8,2),("P2","P9",9,2),("P2","P4",4,2),("P3","P5",5,3),("P3","P7",7,3),("P4","P8",8,4),("P4","P6",6,4),("P4","P10",10,4),("P5","P6",6,5),("P5","P7",7,5),("P5","P10",10,5),("P3","P9",9,3)]
	#links = [("P1", "P2", 2, 1), ("P1", "P6", 6, 1), ("P2", "P3", 3, 2), ("P2", "P7", 7, 2), ("P3", "P4", 4, 3), ("P3", "P8", 8, 3),("P4", "P5", 5, 4), ("P4", "P9", 9, 4),("P6","P7",7,6),("P7","P8", 8, 7), ("P8","P9",9,8)]#3rd parametrer = id du premier routeur, 4rd = id du deuxieme
	for r in router:
		x = {
  			"name": "Swanky",
  			"hostname": r[0],
			"id": r[1],
			"hostname2": r[0].lower(),
  			"passwd": "zebra",
			"router_id": "42.251.23." + str(r[1]),
			"bgp_router_id": "10.10.10."+str(r[1]), 
			"interfaces": [],
			"neighbors": [],
			"router_as" : "65009",
			"cluster_id" : "1.1.1.1"
    		}
		count = 0
		for link in links:
			if link[0] == r[0]:
				d = {}
				d['name'] = "eth"+str(count)
				d['cost'] = 5
				d['hello_time'] = 10
				d['dead_time'] = 40
				d['instance_id'] = 0
				d['destinationR'] = link[1]
				d['adress'] = "fde4:"+"9:0000"+str(r[1])+str(link[2])+"::"+str(r[1])+str(r[1])+"/64"
				d['area'] = "0.0.0.0"
				d['active'] = "true"
				x["interfaces"].append(copy.deepcopy(d))
				count += 1
			if link[1] == r[0]:
				d = {}
				d['name'] = "eth"+str(count)
				d['cost'] = 5
				d['destinationR'] = link[0]
				d['hello_time'] = 10
				d['dead_time'] = 40
				d['instance_id'] = 0
				d['adress'] = "fde4:"+"9:0000"+str(link[3])+str(r[1])+"::"+str(r[1])+str(r[1])+"/64"
				d['area'] = "0.0.0.0"
				d['active'] = "true"
				x["interfaces"].append(d)
				count += 1
                x['cost'] = 5
                x['hello_time'] = 10
		x['loopback_adress'] = "fde4:9::"+str(r[1])+str(r[1])+"/128"
                x['dead_time'] = 40
                x['instance_id'] = 0
		for bgp in bgpLinks:
			if bgp[0] == r[0]:
				d = {}
				d['remote_as'] = "65009"
				d['interface'] = "fde4:9::"+str(r[1])+str(r[1])
				d['MD5_pass'] = "pass9"
				d['reflector'] = True
				x['neighbors'].append(d)
			if bgp[0] == r[1]:
                                d = {}
                                d['remote_as'] = "65009"
                                d['interface'] = "fde4:9::"str(bgp[3]+str(bgp[3])
                                d['MD5_pass'] = "pass9"
                                d['reflector'] = True
                                x['neighbors'].append(d)			
		data = json.dumps(x)
		data = json.loads(data)
		print(data)
		#OSPF FILE
		template = Template(filename="ospf6d.mako")
		with open(("p"+str(r[1])+"_ospf.conf"),'w+') as f:
			f.write(template.render(data=data))
		shutil.move("p"+str(r[1])+"_ospf.conf","our_network_cfg/"+r[0])
		#ZEBRA FILE
		template = Template(filename="zebra.mako")
		with open(("p"+str(r[1])+"_zebra.conf"),'w+') as f:
			f.write(template.render(data=data))
		shutil.move("p"+str(r[1])+"_zebra.conf","our_network_cfg/"+r[0])
		#START FILE
		template = Template(filename="boot.mako")
		with open(("P"+str(r[1])+"_boot"),'w+') as f:
			f.write(template.render(data=data))
			os.chmod(("P"+str(r[1])+"_boot"), 777)
			shutil.move("P"+str(r[1])+"_boot","our_network_cfg/")
		template = Template(filename = "start.mako")
		with open(("P"+str(r[1])+"_start"),'w+') as f:
			f.write(template.render(data=data))
			os.chmod(("P"+str(r[1])+"_start"), 777)
			shutil.move("P"+str(r[1])+"_start","our_network_cfg/")
		if len(x['neighbors'] != 0:
			with open(("p"+str(r[1])+"_bgp.conf"),'w+') as f:
                        	f.write(template.render(data=data))
                        	os.chmod(("p"+str(r[1])+"_bgp.conf"), 777)
                        	shutil.move("p"+str(r[1])+"_bgp.conf","our_network_cfg/")
main()
 
