#!/usr/bin/env python3
import json
import copy

def main():
	router = [("R1",1),("R2",2),("R3",3)]
	links = [("R1", "R2", 2, 1), ("R2", "R3", 3, 2), ("R1", "R3", 3, 1)]
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
				d['instance_id'] = 0
				d['adress'] = "fde0:"+"9:"+str(link[3])+str(r[1])+"::"+str(r[1])+str(r[1])+"/64"
				d['area'] = "0.0.0.0"
				d['active'] = "true"
				x["interfaces"].append(d)
				count += 1
		with open(r[0]+".json", 'w+') as outfile:
    			json.dump(x, outfile)			
main()
cd ..
 
