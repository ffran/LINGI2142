!
! OSPF configuration for ${data['name']}
!
hostname ${data['hostname']}
password ${data['passwd']}
log stdout
service advanced-vty
!
debug ospf6 neighbor state
!
%for interface in data['interfaces']:
interface ${data['hostname']}-${interface['name']}
    ipv6 ospf6 cost ${interface['cost']}
    %if interface['active']:
    ipv6 ospf6 hello-interval ${interface['hello_time']}
    ipv6 ospf6 dead-interval ${interface['dead_time']}
    %else:
    ipv6 ospf6 passive
    %endif
    ipv6 ospf6 instance-id ${interface['instance_id']}
!
%endfor
interface lo
    ipv6 ospf6 cost ${data['cost']}
    ipv6 ospf6 hello-interval ${data['hello_time']}
    ipv6 ospf6 dead-interval ${data['dead_time']}
    ipv6 ospf6 instance-id ${data['instance_id']}
!
router ospf6
    ospf6 router-id ${data['router_id']}
    %for nic in data['interfaces']:
    interface ${data['hostname']}-${nic['name']} area ${nic['area']}
    %endfor
    interface lo area 0.0.0.0
!
