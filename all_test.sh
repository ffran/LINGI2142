#!/bin/bash
sudo ./OSPFLinkFailureTests.sh
sudo ./OSPFTests.sh
echo "Tests pour OSPF lancé et rapport créé !"
sudo ./BgpTests.sh
echo "Tests pour BGP lancé et rapport créé !"
sudo ./SecurityTests.sh
echo "Tests pour la sécurité lancé et rapport créé !"
