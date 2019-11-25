#!/bin/bash
adress=(fde4:9::33)
routers=(P1)
for r in ${routers[@]};
do
for t in ${adress[@]}; 
do
sudo ip netns exec $r ping6 $t -c25 > /dev/null
if [ "${?}" -ne 0 ]; then
echo "Firewall contre le flooding fonctionnel ! Attaque maitrisée ! ${r} to ${t}" >> Rapport_Securite_Test
else
echo "Firewall non fonctionnel, attaque non contrée ..." >> Rapport_Securite_Test
fi   
done
done

#sudo ./connect_to.sh automatetest_cfg P1 && 
#ping6 fde4:9::1111 -c5  > /dev/null

