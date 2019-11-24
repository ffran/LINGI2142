!
! BGP configuration for ${data['name']}
!
hostname ${data['hostname']}
password ${data['passwd']}
log stdout
!
router bgp ${data['router_as']}
bgp router-id ${data['bgp_router_id']}
no bgp default ipv4-unicast
!

%for neighbor in data['ebgp_neighbor']:
neighbor ${neighbor['interface']} remote-as ${neighbor['remote_as']}
neighbor ${neighbor['interface']} interface ${neighbor['our_interface']}
%if neighbor['security_hop']!=' ':
neighbor ${neighbor['interface']} ttl-security hops ${neighbor['security_hop']}
%endif
%if neighbor['MD5_pass']!=' ':
neighbor ${neighbor['interface']} password pass9 ${neighbor['MD5_pass']}
%endif
%endfor

%for neighbor in data['neighbors']:
neighbor ${neighbor['interface']} remote-as ${data['router_as']}
neighbor ${neighbor['interface']} interface ${data['loopback_adress']}
neighbor ${neighbor['interface']} update-source lo
neighbor ${neighbor['interface']} password pass9


%endfor

%if data['cluster_id'] != ' ':
bgp cluster-id ${data['cluster_id']}
%endif
!
address-family ipv6 unicast
!
network fde4:9::/32
!
%for neighbor in data['ebgp_neighbor']:
neighbor ${neighbor['interface']} activate
%endfor

%for neighbor in data['neighbors']:
neighbor ${neighbor['interface']} activate
neighbor ${neighbor['interface']} next-hop-self
%if neighbor['reflector']:
neighbor ${neighbor['interface']} route-reflector-client
%endif
%if neighbor['access-list_in']!=' ':
neighbor ${neighbor['interface']} distribute-list ${neighbor['access-list_in']} in
%endif
%if neighbor['access-list_out']!=' ':
neighbor ${neighbor['interface']} distribute-list ${neighbor['access-list_out']} out
%endif

%endfor
exit-address-family
!

%for access in data['access-list']:
ipv6 access-list ${access['name']} ${access['type']} ${access['prefix']}
%endfor
