!
! BGP configuration for ${data['name']}
!
hostname ${data['hostname']}
password ${data['passwd']}
log stdout
!
router bgp ${data['router_as']}
bgp router ${data['bgp_router_id']}
no bgp default ipv4-unicast
!
%for neighbor in data['neighbors']:
neighbor ${neighbor['interface']} ${neighbor['remote_as']}
neighbor ${neighbor['interface']} interface ${data['loopback_adress']}
neighbor ${neighbor['interface']} update-source lo
%if neighbor['remote_as']==data['router_as']:
neighbor ${neighbor['interface']} password pass9
%endif
%if neighbor['access-list_in']!=' ':
neighbor ${neighbor['interface']} distribute-list ${neighbor['access-list_in']} in
%endif
%if neighbor['access-list_out']!=' ':
neighbor ${neighbor['interface']} distribute-list ${neighbor['access-list_out']} out
%endif

%endfor
bgp cluster-id ${data['cluster_id']}
!
address-family ipv6 unicast
!
network fde4:9::/32
!
%for neighbor in data['neighbors']:
neighbor ${neighbor['interface']} activate
neighbor ${neighbor['interface']} next-hop-self
%if neighbor['reflector']:
neighbor ${neighbor['interface']} route-reflector-client
%endif

%endfor
exit-address-family
!

%for access in data['access-list']:
ipv6 access-list ${access['name']} ${access['type']} ${access['prefix']}
%endfor
