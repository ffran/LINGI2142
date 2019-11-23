#!/usr/bin/env python3
import json
import copy
import make_router_conf as mf
import os
from mako.template import Template
import shutil



#TODO : gérer les cas ou le numero du routeur est > 10 (passage en hexadecimal) + automatiser create_network
def main():			
		data = []
		with open("essai.txt",'r') as f, open('showjson', 'w+') as b:
			data = f.readlines()
			b.write("[")
			read = False
			first = True
			for line in data:
				line2 = line.split()
				if len(line2) > 1 and "show"==line2[1]:
					read = not read
					if not first:
						b.write(",")
					first = False
				elif read and len(line2) != 0 and "group9" in line2[0]:
					read = False
				else:
					if read:
						b.write(line)
			b.write("]")
		with open("showjson") as f:
			data = json.load(f)
		with open("Rapport_Test_BGP.txt", "w+") as a:
			for d in data:
				d=d["ipv6Unicast"]
				for peers in d['peers']:
					print(peers)
					if peers['connectionsEstablished'] == 1:
						a.write("Connection BGP établie du router : "+str(d["routerId"]) + "à l'adresse ")
					else:
						a.write("Connection BGP non établie du router : "+str(d["routerId"]) + "à l'adresse ")   
main()
 
