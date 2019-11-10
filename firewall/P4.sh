#!/bin/bash

#flush older table

ip6tables -F INPUT
ip6tables -F OUTPUT
ip6tables -F
ip6tables -X

#drop by default if no rules 
ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT DROP

#allow local
ip6tables -A INPUT -i lo -j ACCEPT
ip6tables -A OUTPUT -o lo -j ACCEPT

# Allow ICMPv6
ip6tables -A INPUT -p ipv6-icmp -j ACCEPT
ip6tables -A FORWARD -p ipv6-icmp -j ACCEPT
ip6tables -A OUTPUT -p ipv6-icmp -j ACCEPT


#allow OSPF (number protocol = 89)
ip6tables -A INPUT -p 89 -j ACCEPT
ip6tables -A OUTPUT -p 89 -j ACCEPT
ip6tables -A FORWARD -p 89 -j ACCEPT

#allow traceroute
ip6tables -I INPUT -p udp --dport 33434:33474 -j ACCEPT
ip6tables -I FORWARD -p udp --dport 33434:33474 -j ACCEPT
ip6tables -I OUTPUT -p udp --dport 33434:33474 -j ACCEPT

#allow BGP
ip6tables -A INPUT -p tcp --dport 179 -j ACCEPT
ip6tables -A INPUT -p tcp --sport 179 -j ACCEPT
ip6tables -A OUTPUT -p tcp --dport 179 -j ACCEPT
ip6tables -A OUTPUT -p tcp --sport 179 -j ACCEPT


#record dropped packet (source : https://www.thegeekstuff.com/2012/08/iptables-log-packets/)

#ip6tables -N LOGGING
#ip6tables -A INPUT -j LOGGING
#ip6tables -A OUTPUT -j LOGGING0
#ip6tables -A LOGGING -m limit --limit 2/min -j LOG --log-prefix "IPTables-Dropped: " --log-level 4
#ip6tables -A LOGGING -j DROP
