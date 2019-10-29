#!/bin/sh
#test on P2 P5 P7 P8 P10
echo 'we sent 3 ping to P2'
ping6 -c 3 fde4:9:12::22
echo 'we sent 3 ping to P5'
ping6 -c 3 fde4:9:35::55
echo 'we sent 3 ping to P8'
ping6 -c 3 fde4:9:28::88
echo 'we sent 3 ping to P7'
ping6 -c 3 fde4:9:37::77
echo 'we sent 3 ping to P10'
ping6 -c 3 fde4:9:410::1010

echo 'traceroute to P2'
traceroute6 fde4:9:12::22
echo 'traceroute to P5'
traceroute6 fde4:9:35::55
echo 'traceroute to P8'
traceroute6 fde4:9:28::88
echo 'traceroute to P7'
traceroute6 fde4:9:37::77
echo 'traceroute to P10'
traceroute6 fde4:9:410::1010
