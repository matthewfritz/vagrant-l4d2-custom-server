#! /bin/bash

# Left 4 Dead 2 provisioning

STEAMCMD_MOUNT="/mnt/data/steamcmd"
STEAMCMD_MAP_START="c2m1_highway"
STEAMCMD_PORT="27020"
STEAMCMD_HOME="/home/vagrant"
STEAMCMD_L4D2_DIR="${STEAMCMD_HOME}/l4d2_server"

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
echo "${STEAMCMD_L4D2_DIR}/srcds_run -console -game left4dead2 -port ${STEAMCMD_PORT} -maxplayers 8 +exec server.cfg +map ${STEAMCMD_MAP_START}" > ${STEAMCMD_HOME}/start_l4d2.sh
chmod +x ${STEAMCMD_HOME}/start_l4d2.sh
output_line "Finished creating startup script"

output_line "Creating Left 4 Dead 2 server update script..."
echo "${STEAMCMD_HOME}/steamcmd.sh +runscript ${STEAMCMD_MOUNT}/update_l4d2.txt" > ${STEAMCMD_HOME}/update_l4d2.sh
chmod +x ${STEAMCMD_HOME}/update_l4d2.sh
output_line "Finished creating update script"

output_line "Running steamcmd with the custom update script to download and install the Left 4 Dead 2 server..."
./steamcmd.sh +runscript ${STEAMCMD_MOUNT}/update_l4d2.txt
output_line "Finished running steamcmd"

# https://wiki.alliedmods.net/Installing_Metamod:Source
output_line "Downloading and installing Metamod..."
wget https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1148-linux.tar.gz
tar xf mmsource-1.11.0-git1148-linux.tar.gz
mv ${STEAMCMD_HOME}/addons/* ${STEAMCMD_L4D2_DIR}/left4dead2/addons
rmdir ${STEAMCMD_HOME}/addons
output_line "Finished downloading and installing Metamod"

# https://wiki.alliedmods.net/Installing_SourceMod
output_line "Downloading and installing Sourcemod..."
wget https://sm.alliedmods.net/smdrop/1.11/sourcemod-1.11.0-git6936-linux.tar.gz
tar xf sourcemod-1.11.0-git6936-linux.tar.gz
mv ${STEAMCMD_HOME}/addons/metamod/* ${STEAMCMD_L4D2_DIR}/left4dead2/addons/metamod
mv ${STEAMCMD_HOME}/addons/sourcemod ${STEAMCMD_L4D2_DIR}/left4dead2/addons
rm -rf ${STEAMCMD_HOME}/addons
mv ${STEAMCMD_HOME}/cfg/sourcemod/* ${STEAMCMD_L4D2_DIR}/left4dead2/cfg/sourcemod
rm -rf ${STEAMCMD_HOME}/cfg
output_line "Finished downloading and installing Sourcemod"

output_line "Adding Sourcemod admins..."
cat ${STEAMCMD_MOUNT}/sourcemod/admins_simple_lines.ini >> ${STEAMCMD_L4D2_DIR}/left4dead2/addons/sourcemod/configs/admins_simple.ini
output_line "Finished adding Sourcemod admins"

# https://github.com/SmartlyDressedGames/Unturned-3.x-Community/issues/2305#issuecomment-785075753
output_line "Making symlink to steamclient.so..."
mkdir -p ${STEAMCMD_HOME}/.steam/sdk32
ln -s ${STEAMCMD_HOME}/linux32/steamclient.so ${STEAMCMD_HOME}/.steam/sdk32/steamclient.so
output_line "Finished making symlink to steamclient.so"

output_line "Making symlink to L4D2 server.cfg file..."
ln -s ${STEAMCMD_MOUNT}/l4d2_server.cfg ${STEAMCMD_L4D2_DIR}/left4dead2/cfg/server.cfg
output_line "Finished making symlink to server.cfg"

output_line "Finished Left 4 Dead 2 provisioning" 