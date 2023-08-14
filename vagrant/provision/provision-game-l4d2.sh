#! /bin/bash

# Left 4 Dead 2 provisioning

# credentials for the user that will be calling steamcmd (change as necessary)
STEAMCMD_USER="steam"

output_line() {
    echo "[L4D2] $1"
}

output_line "Beginning Left 4 Dead 2 provisioning..."
su -u ${STEAMCMD_USER} -s
cd ~

output_line "Running steamcmd with the custom update script..."
steamcmd +runscript /mnt/data/steamcmd/update_l4d2.txt
output_line "Finished running steamcmd"

output_line "Creating Left 4 Dead 2 server startup script..."
echo "~/l4d2_server/srcds_run -console -game left4dead2 +port 27020 +maxplayers 8 +exec /mnt/data/steamcmd/server.cfg +map c2m1_highway" > ~/start_l4d2.sh
chmod +x ~/start_l4d2.sh
output_line "Finished creating startup script"

output_line "Finished Left 4 Dead 2 provisioning"