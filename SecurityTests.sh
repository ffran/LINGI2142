#!/bin/bash
adress=(fde4:9::33)
routers=(P1)
for r in ${routers[@]};
do
for t in ${adress[@]}; 
do
sudo ip netns exec $r ping6 $t -c30 -f | grep 'loss' > /dev/null
val=$(cut -d " " -f4 Rapport_Securite_Test)
echo "$val"
if [ $val -lt 15 ]; then
echo "Firewall contre le flooding fonctionnel ! Attaque maitrisée ! ${r} to ${t}" >> Rapport_Securite_Test
else
echo "Firewall non fonctionnel, attaque non contrée ..." >> Rapport_Securite_Test
fi   
done
done

