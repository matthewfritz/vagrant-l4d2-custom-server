#! /bin/bash

# Left 4 Dead 2 provisioning

STEAMCMD_MOUNT="/mnt/data/steamcmd"
STEAMCMD_MAP_START="c2m1_highway"
STEAMCMD_PORT="27020"
STEAMCMD_HOME="/home/vagrant"

output_line() {
    echo "[L4D2] $1"
}

output_line "Beginning Left 4 Dead 2 provisioning..."

# On CentOS 7, steamcmd isn't within yum by default so we will install it manually
# https://www.vultr.com/docs/how-to-install-steamcmd-on-your-vps#3__Install_Steam
output_line "Installing steamcmd..."
wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar xf steamcmd_linux.tar.gz
./steamcmd.sh +quit
output_line "Finished installing steamcmd"

output_line "Creating Left 4 Dead 2 server startup script..."
echo "${STEAMCMD_HOME}/l4d2_server/srcds_run -console -game left4dead2 +port ${STEAMCMD_PORT} +maxplayers 8 +exec ${STEAMCMD_MOUNT}/l4d2_server.cfg +map ${STEAMCMD_MAP_START}" > ${STEAMCMD_HOME}/start_l4d2.sh
chmod +x ${STEAMCMD_HOME}/start_l4d2.sh
output_line "Finished creating startup script"

output_line "Creating Left 4 Dead 2 server update script..."
echo "${STEAMCMD_HOME}/steamcmd.sh +runscript ${STEAMCMD_MOUNT}/update_l4d2.txt" > ${STEAMCMD_HOME}/update_l4d2.sh
chmod +x ${STEAMCMD_HOME}/update_l4d2.sh
output_line "Finished creating update script"

output_line "Running steamcmd with the custom update script to download and install the Left 4 Dead 2 server..."
./steamcmd.sh +runscript ${STEAMCMD_MOUNT}/update_l4d2.txt
output_line "Finished running steamcmd"

output_line "Finished Left 4 Dead 2 provisioning" 