#! /bin/bash

# common box provisioning

output_line() {
    echo "[BASE] $1"
}

output_line "Beginning base machine provisioning..."
yum -y upgrade

output_line "Setting firewall rules..."
iptables -I INPUT -p udp -m state --state NEW -m udp --dport 3478 -j ACCEPT
iptables -I INPUT -p udp -m state --state NEW -m udp --dport 4379:4380 -j ACCEPT
iptables -I INPUT -p udp -m state --state NEW -m udp --dport 7777 -j ACCEPT
iptables -I INPUT -p udp -m state --state NEW -m udp --dport 10999 -j ACCEPT
iptables -I INPUT -p udp -m state --state NEW -m udp --dport 27014 -j ACCEPT
iptables -I INPUT -p udp -m state --state NEW -m udp --dport 27015 -j ACCEPT
iptables -I INPUT -p udp -m state --state NEW -m udp --dport 27016:27030 -j ACCEPT
iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 27015 -j ACCEPT
iptables-save
output_line "Finished setting firewall rules"

output_line "Installing steamcmd dependencies..."
yum -y install glibc.i686 libstdc++.i686 wget
output_line "Finished installing steamcmd dependencies"

output_line "Finished base machine provisioning"