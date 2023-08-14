#! /bin/bash

# Left 4 Dead 2 provisioning

STEAMCMD_MOUNT="/mnt/data/steamcmd"
STEAMCMD_MAP_START="c2m1_highway"
STEAMCMD_PORT="27020"

# credentials for the user that will be calling steamcmd (change as necessary)
STEAMCMD_USER="steam"

output_line() {
    echo "[L4D2] $1"
}

output_line "Beginning Left 4 Dead 2 provisioning..."
su -u ${STEAMCMD_USER} -s
cd ~

output_line "Creating Left 4 Dead 2 server startup script..."
echo "~/l4d2_server/srcds_run -console -game left4dead2 +port ${STEAMCMD_PORT} +maxplayers 8 +exec ${STEAMCMD_MOUNT}/l4d2_server.cfg +map ${STEAMCMD_MAP_START}" > ~/start_l4d2.sh
chmod +x ~/start_l4d2.sh
output_line "Finished creating startup script"

output_line "Running steamcmd with the custom update script..."
steamcmd +runscript ${STEAMCMD_MOUNT}/update_l4d2.txt
output_line "Finished running steamcmd"

output_line "Finished Left 4 Dead 2 provisioning" 