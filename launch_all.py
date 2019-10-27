#!/usr/bin/env python3
import json
import copy
import make_router_conf as mf
import os
from mako.template import Template
import shutil



#TODO : gérer les cas ou le numero du routeur est > 10 (passage en hexadecimal) + automatiser create_network
def main():
	#os.mkdir("automatetest.cfg")
	router = [("R1",1),("R2",2),("R3",3)]
	links = [("R1", "R2", 2, 1), ("R2", "R3", 3, 2), ("R1", "R3", 3, 1)]#3rd parametrer = id du premier routeur, 4rd = id du deuxieme
	for r in router:
		x = {
  			"name": "Swanky",
  			"hostname": r[0],
  			"passwd": "zebra",
			"router_id": "0.251.23." + str(r[1]),
			"interfaces": []
    		}
		count = 0
		for link in links:
			if link[0] == r[0]:
				d = {}
				d['name'] = "eth"+str(count)
				d['cost'] = 5
				d['hello_time'] = 40
				d['dead_time'] = 40
				d['instance_id'] = 0
				d['adress'] = "fde0:"+"9:"+str(r[1])+str(link[2])+"::"+str(r[1])+str(r[1])+"/64"
				d['area'] = "0.0.0.0"
				d['active'] = "true"
				x["interfaces"].append(copy.deepcopy(d))
				count += 1
			if link[1] == r[0]:
				d = {}
				d['name'] = "eth"+str(count)
				d['cost'] = 5
				d['hello_time'] = 40
				d['dead_time'] = 40
				d['instance_id'] = 0
				d['adress'] = "fde0:"+"9:"+str(link[3])+str(r[1])+"::"+str(r[1])+str(r[1])+"/64"
				d['area'] = "0.0.0.0"
				d['active'] = "true"
				x["interfaces"].append(d)
				count += 1
		data = json.dumps(x)
		data = json.loads(data)
		print(data)
		#OSPF FILE
		template = Template(filename="ospf6d.mako")
		with open(("r"+str(r[1])+"_ospf.conf"),'w+') as f:
			f.write(template.render(data=data))
		shutil.move("r"+str(r[1])+"_ospf.conf","automatetest.cfg/"+r[0])
		#ZEBRA FILE
		template = Template(filename="zebra.mako")
		with open(("r"+str(r[1])+"_zebra.conf"),'w+') as f:
			f.write(template.render(data=data))
		shutil.move("r"+str(r[1])+"_zebra.conf","automatetest.cfg/"+r[0])
		#START FILE
		with open(("R"+str(r[1])+"_boot"),'w+') as f:
			f.write(template.render(data=data))
			os.chmod(("R"+str(r[1])+"_boot"), 777)
			shutil.move("R"+str(r[1])+"_boot","automatetest.cfg/")
		with open(("R"+str(r[1])+"_start"),'w+') as f:
			f.write(template.render(data=data))
			os.chmod(("R"+str(r[1])+"_start"), 777)
			shutil.move("R"+str(r[1])+"_start","automatetest.cfg/")
main()
 
