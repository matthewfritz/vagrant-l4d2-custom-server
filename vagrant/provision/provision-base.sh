#! /bin/bash

# common box provisioning

# credentials for the user that will be calling steamcmd (change as necessary)
STEAMCMD_USER="steam"
STEAMCMD_PASS="steam"

output_line() {
    echo "[BASE] $1"
}

output_line "Beginning base machine provisioning..."
yum -y update > /dev/null

output_line "Setting firewall rules..."
iptables -I INPUT -p tcp -m state --state NEW -m udp --dport 3478 -j ACCEPT
iptables -I INPUT -p tcp -m state --state NEW -m udp --dport 4379:4380 -j ACCEPT
iptables -I INPUT -p tcp -m state --state NEW -m udp --dport 7777 -j ACCEPT
iptables -I INPUT -p tcp -m state --state NEW -m udp --dport 10999 -j ACCEPT
iptables -I INPUT -p tcp -m state --state NEW -m udp --dport 27014 -j ACCEPT
iptables -I INPUT -p tcp -m state --state NEW -m udp --dport 27015 -j ACCEPT
iptables -I INPUT -p tcp -m state --state NEW -m udp --dport 27016:27030 -j ACCEPT
iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 27015 -j ACCEPT
iptables-save
output_line "Finished setting firewall rules"

output_line "Creating steam user..."
useradd -m "${STEAMCMD_USER}"
echo "${STEAMCMD_USER}:${STEAMCMD_PASS}" | chpasswd
output_line "Finished creating steam user"

output_line "Installing steamcmd..."
yum -y install steamcmd
output_line "Finished installing steamcmd"

output_line "Finished base machine provisioning"