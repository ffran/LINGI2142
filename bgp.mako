!
hostname bgpd
password zebra
log stdout
!
router bgp 65009
bgp router-id ${data['id']}.${data['id']}.${data['id']}.${data['id']}
no bgp default ipv4-unicast

bgp cluster-id X.X.X.X
!
address-family ipv6 unicast
network fde4:9::/32
neighbor fde4:9::11 activate
neighbor fde4:9::11 next-hop-self

neighbor fde4:9::22 activate
neighbor fde4:9::22 next-hop-self

neighbor fde4:9::33 activate
neighbor fde4:9::33 next-hop-self

neighbor fde4:9::44 activate
neighbor fde4:9::44 next-hop-self
neighbor fde4:9::44 route-reflector-client

neighbor fde4:9::55 activate

exit-adress-family
