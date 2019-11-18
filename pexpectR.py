#!/usr/bin/env python3
import json
import copy
import make_router_conf as mf
import os
import time
import pexpect
from mako.template import Template
import shutil



#TODO : gérer les cas ou le numero du routeur est > 10 (passage en hexadecimal) + automatiser create_network
def main():
	router = pexpect.spawn('sudo ./connect_to.sh automatetest_cfg P1')
	router.sendline('ping6 fde4:9::1111')
	router.expect('PING')
	print(router.before)
main()
 
