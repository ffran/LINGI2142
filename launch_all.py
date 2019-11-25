#!/usr/bin/env python3
import json
import copy
import make_router_conf as mf
import os
from mako.template import Template
import shutil



def main():
	folder = "automatetest_cfg/"
	router = [("P1",1),("P2",2),("P3",3),("P4",4),("P5",5),("P6",6),("P7",7),("P8",8),("P9",9),("P10",10),("P11",11),("P91",91),("P92",92)]
	bgpLinks = [("P1", "P2", 2, 1),("P2", "P3", 3, 2),("P1","P9",9,1),("P1","P11",11,1),("P9","P11",11,9),("P1","P3",3,1),("P3","P9",9,3),("P9","P10",10,9),("P10","P11",11,10),("P3","P4",4,3),("P4","P10",10,4),("P2","P5",5,2),("P5","P10",10,5)]
	bgpInterfaces = [("P1","king4","fde4:9::8:caf9/64"),("P3","king3","fde4:9::1:caf9/64"),("P4","client_1-1","fde4:9::c1:face/64"),("P5","client_1-2","fde4:9::c1c1:face/64"),("P10","king2","fde4:6::9:cafe/64"),("P11","king","fde4::9:cafe/64"),("P91","bgp1","fde4:9::c1:caf9/64"),("P92","bgp2","fde4:9::c1c1:caf9/64")]
	cluster1 = ["P1","P11","P9"]
	cluster2 = ["P10","P3","P2"] 
	router_as_65099 = ["P91","P92"]
	client_1111 = ["P91","P92"]
	links = [("P1","P3",3,1),("P1","P2",2,1),("P2","P3",3,2),("P3","P4",4,3),("P4","P5",5,4),("P2","P5",5,2),("P2","P9",9,2),("P4","P9",9,4),("P4","P10",10,4),("P9","P10",10,9),("P9","P11",11,9),("P5","P10",10,5),("P10","P11",11,10),("P91","P92",92,91)]
	for r in router:
		Cluster_id = None
		if r[0] in cluster1:
			Cluster_id = "1.1.1.1"
		elif r[0] in cluster2:
			Cluster_id = "2.2.2.2"
		if r[0] in router_as_65099:
			router_as = "65099"
		else:
			router_as = "65009"
		if r[0] in client_1111:
			subnet = "1111"
		else:
			subnet = "0000"
		x = {
  			"name": "Swanky",
  			"hostname": r[0],
			"id": r[1],
			"hostname2": r[0].lower(),
  			"passwd": "zebra",
			"router_id": "42.251.23." + str(r[1]),
			"bgp_router_id": "10.10.10."+str(r[1]), 
			"interfaces": [],
			"bgpInterface": [],
			"neighbors": [],
			"router_as" : router_as,
			"cluster_id" : Cluster_id
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
				d['adress'] = "fde4:"+"9:"+subnet+":"+str(r[1])+str(link[2])+"::"+str(r[1])+str(r[1])+"/64"
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
				d['adress'] = "fde4:"+"9:"+subnet+":"+str(link[3])+str(r[1])+"::"+str(r[1])+str(r[1])+"/64"
				d['area'] = "0.0.0.0"
				d['active'] = "true"
				x["interfaces"].append(d)
				count += 1
		x['cost'] = 5
		x['hello_time'] = 10
		x['loopback_adress'] = "fde4:9:"+subnet+"::"+str(r[1])+str(r[1])+"/128"
		x['dead_time'] = 40
		x['instance_id'] = 0
		for bgpInt in bgpInterfaces:
			if bgpInt[0] == r[0]:
				d = {}
				d['name'] = bgpInt[1]
				d['adress'] = bgpInt[2]
				x['bgpInterface'].append(d)
		for bgp in bgpLinks:
			if bgp[0] == r[0]:
				d = {}
				d['remote_as'] = "65009"
				d['interface'] = "fde4:9:"+subnet+"::"+str(r[1])+str(r[1])
				d['MD5_pass'] = "pass9"
				d['reflector'] = True
				x['neighbors'].append(d)
			if bgp[0] == r[1]:
				d = {}
				d['remote_as'] = "65009"
				d['interface'] = "fde4:9:"+subnet+":"+str(bgp[3])+str(bgp[3])
				d['MD5_pass'] = "pass9"
				d['reflector'] = True
				x['neighbors'].append(d)			
		data = json.dumps(x)
		data = json.loads(data)
		#OSPF FILE
		template = Template(filename="ospf6d.mako")
		with open(("p"+str(r[1])+"_ospf.conf"),'w+') as f:
			f.write(template.render(data=data))
		shutil.move("p"+str(r[1])+"_ospf.conf",folder+r[0])
		#ZEBRA FILE
		template = Template(filename="zebra.mako")
		with open(("p"+str(r[1])+"_zebra.conf"),'w+') as f:
			f.write(template.render(data=data))
		shutil.move("p"+str(r[1])+"_zebra.conf",folder+r[0])
		#START FILE
		template = Template(filename="boot.mako")
		with open(("P"+str(r[1])+"_boot"),'w+') as f:
			f.write(template.render(data=data))
			os.chmod(("P"+str(r[1])+"_boot"), 777)
			shutil.move("P"+str(r[1])+"_boot",folder)
		template = Template(filename = "start.mako")
		with open(("P"+str(r[1])+"_start"),'w+') as f:
			f.write(template.render(data=data))
			os.chmod(("P"+str(r[1])+"_start"), 777)
			shutil.move("P"+str(r[1])+"_start",folder)
		print(len(x['neighbors']))
		print(x['neighbors'])
		#template = Template(filename = "bgp.mako")
		#if (len(x['neighbors']) != 0):
		#	with open(("p"+str(r[1])+"_bgp.conf"),'w+') as f:
                #       	f.write(template.render(data=data))
		#	shutil.move("p"+str(r[1])+"_bgp.conf",folder+r[0])
		#with open(("P"+str(r[1])+".json"),'w') as f:
		#	json.dumps(data,f)
main()
 
