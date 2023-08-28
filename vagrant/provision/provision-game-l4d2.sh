#! /bin/bash

# Left 4 Dead 2 provisioning

STEAMCMD_HOME="/home/vagrant"
STEAMCMD_MOUNT="/mnt/data/left4dead2"
STEAMCMD_MAP_START="c2m1_highway"
STEAMCMD_PORT="27020"

STEAMCMD_L4D2_DIR="${STEAMCMD_HOME}/l4d2_server"
STEAMCMD_L4D2_ADDONS_DIR="${STEAMCMD_L4D2_DIR}/left4dead2/addons"
STEAMCMD_L4D2_CFG_DIR="${STEAMCMD_L4D2_DIR}/left4dead2/cfg"
STEAMCMD_L4D2_METAMODMOD_DIR="${STEAMCMD_L4D2_ADDONS_DIR}/metamod"
STEAMCMD_L4D2_SOURCEMOD_DIR="${STEAMCMD_L4D2_ADDONS_DIR}/sourcemod"

L4D2_GENERATED_SERVER_CFG="${STEAMCMD_HOME}/l4d2_server_generated.cfg"
L4D2_SRCDS_MAX_PLAYERS=8

# GitHub mirror of the necessary dependencies so we can provision in a consistent way and not worry about
# our requisite configs, mods, etc. disappearing suddenly and breaking our server
DEPENDENCY_BASE_URL="https://github.com/matthewfritz/vagrant-l4d2-custom-server/raw/dependencies"

output_line() {
    echo "[L4D2] $1"
}

output_line "Beginning Left 4 Dead 2 provisioning..."

##################################################################################
#
# STEAMCMD PROVISIONING (CORE)
#
##################################################################################

# On CentOS 7, steamcmd isn't within yum by default so we will install it manually
# https://www.vultr.com/docs/how-to-install-steamcmd-on-your-vps#3__Install_Steam
output_line "Installing steamcmd..."
wget ${DEPENDENCY_BASE_URL}/core/steamcmd_linux.tar.gz
tar xf steamcmd_linux.tar.gz
./steamcmd.sh +quit
rm steamcmd_linux.tar.gz
output_line "Finished installing steamcmd"

output_line "Creating steamcmd update script for the Left 4 Dead 2 server..."
cat <<STEAMCMD_UPDATE > ${STEAMCMD_HOME}/steamcmd_update_l4d2.txt
// steamcmd_update_l4d2.txt
// https://developer.valvesoftware.com/wiki/Dedicated_Servers_List
// L4D2 app ID: 222860
//
@ShutdownOnFailedCommand 1
@NoPromptForPassword 1
force_install_dir ${STEAMCMD_L4D2_DIR}
login anonymous
app_update 222860 validate
quit
STEAMCMD_UPDATE
output_line "Finished creating steamcmd update script"

output_line "Running steamcmd with the custom update script to download and install the Left 4 Dead 2 server..."
./steamcmd.sh +runscript ${STEAMCMD_HOME}/steamcmd_update_l4d2.txt
output_line "Finished running steamcmd"

##################################################################################
#
# METAMOD PROVISIONING (CORE)
#
##################################################################################

# https://wiki.alliedmods.net/Installing_Metamod:Source
output_line "Downloading and installing Metamod..."
output_line "Version: 1.11.0.1148 [26-Jun-2022]"
output_line "AlliedModders URL: https://wiki.alliedmods.net/Installing_Metamod:Source"
mkdir metamod
wget ${DEPENDENCY_BASE_URL}/core/mmsource-1.11.0-git1148-linux.tar.gz
tar xf mmsource-1.11.0-git1148-linux.tar.gz -C metamod
mv metamod/addons/* ${STEAMCMD_L4D2_ADDONS_DIR}
rm -rf metamod
rm mmsource-1.11.0-git1148-linux.tar.gz
output_line "Finished downloading and installing Metamod"

##################################################################################
#
# SOURCEMOD PROVISIONING (CORE)
#
##################################################################################

# https://wiki.alliedmods.net/Installing_SourceMod
output_line "Downloading and installing Sourcemod..."
output_line "Version: 1.11.0.6936 [25-Jul-2023]"
output_line "AlliedModders URL: https://wiki.alliedmods.net/Installing_SourceMod"
mkdir sourcemod
wget ${DEPENDENCY_BASE_URL}/core/sourcemod-1.11.0-git6936-linux.tar.gz
tar xf sourcemod-1.11.0-git6936-linux.tar.gz -C sourcemod
mv sourcemod/addons/metamod/* ${STEAMCMD_L4D2_METAMODMOD_DIR}
mv sourcemod/addons/sourcemod ${STEAMCMD_L4D2_ADDONS_DIR}
mv sourcemod/cfg/sourcemod/* ${STEAMCMD_L4D2_CFG_DIR}/sourcemod
rm -rf sourcemod
rm sourcemod-1.11.0-git6936-linux.tar.gz
output_line "Finished downloading and installing Sourcemod"

# https://forums.alliedmods.net/showthread.php?t=321696
# Replacement for Left 4 Downtown which *REALLY* does not want to work on Linux now
output_line "Downloading and installing Left 4 DHooks Direct plugin for Sourcemod..."
output_line "Version: 1.135 [18-Aug-2023]"
output_line "AlliedModders URL: https://forums.alliedmods.net/showthread.php?t=321696"
wget ${DEPENDENCY_BASE_URL}/core/sourcemod/left4dhooks.zip
unzip left4dhooks.zip -d left4dhooks
mv left4dhooks/sourcemod/data/* ${STEAMCMD_L4D2_SOURCEMOD_DIR}/data
mv left4dhooks/sourcemod/gamedata/* ${STEAMCMD_L4D2_SOURCEMOD_DIR}/gamedata
mv left4dhooks/sourcemod/plugins/* ${STEAMCMD_L4D2_SOURCEMOD_DIR}/plugins
cp -r left4dhooks/sourcemod/scripting/* ${STEAMCMD_L4D2_SOURCEMOD_DIR}/scripting
rm -rf left4dhooks
rm left4dhooks.zip
output_line "Finished downloading and installing Left 4 DHooks Direct plugin for Sourcemod"

# https://forums.alliedmods.net/showthread.php?p=830069
output_line "Downloading and installing SuperVersus plugin for Sourcemod..."
output_line "Version: 1.5.4 [06-Dec-2009]"
output_line "AlliedModders URL: https://forums.alliedmods.net/showthread.php?p=830069"
wget ${DEPENDENCY_BASE_URL}/core/sourcemod/superversus-1.5.4-l4d2.zip
unzip superversus-1.5.4-l4d2.zip -d superversus
mv superversus/cfg/*.cfg ${STEAMCMD_L4D2_CFG_DIR}/sourcemod
mv superversus/plugins/*.smx ${STEAMCMD_L4D2_SOURCEMOD_DIR}/plugins
rm -rf superversus
rm superversus-1.5.4-l4d2.zip
output_line "Finished downloading and installing SuperVersus plugin for Sourcemod"

# https://forums.alliedmods.net/showthread.php?t=298649
output_line "Downloading and installing L4D & L4D2 ThirdPersonShoulder_Detect gameplay plugin for Sourcemod..."
output_line "Version: 1.5.3 [06-Aug-2020]"
output_line "AlliedModders URL: https://forums.alliedmods.net/showthread.php?t=298649"
wget ${DEPENDENCY_BASE_URL}/core/sourcemod/l4d_third_person_shoulder_detect.zip
unzip l4d_third_person_shoulder_detect.zip -d l4d_third_person_shoulder_detect
mv l4d_third_person_shoulder_detect/addons/sourcemod/plugins/* ${STEAMCMD_L4D2_SOURCEMOD_DIR}/plugins
cp -r l4d_third_person_shoulder_detect/addons/sourcemod/scripting/* ${STEAMCMD_L4D2_SOURCEMOD_DIR}/scripting
rm -rf l4d_third_person_shoulder_detect
rm l4d_third_person_shoulder_detect.zip
output_line "Finished downloading and installing L4D & L4D2 ThirdPersonShoulder_Detect gameplay plugin for Sourcemod"

# https://forums.alliedmods.net/showthread.php?t=308708
output_line "Downloading and installing Improved Automatic Campaign Switcher (ACS) plugin for Sourcemod..."
output_line "Version: 2.3.0 [25-Oct-2020]"
output_line "AlliedModders URL: https://forums.alliedmods.net/showthread.php?t=308708"
wget ${DEPENDENCY_BASE_URL}/core/sourcemod/acs_v2.3.0.zip
unzip acs_v2.3.0.zip -d acs
mv acs/gamedata/* ${STEAMCMD_L4D2_SOURCEMOD_DIR}/gamedata
mv acs/plugins/* ${STEAMCMD_L4D2_SOURCEMOD_DIR}/plugins
cp -r acs/scripting/* ${STEAMCMD_L4D2_SOURCEMOD_DIR}/scripting
cp -r acs/translations/* ${STEAMCMD_L4D2_SOURCEMOD_DIR}/translations
rm -rf acs
rm acs_v2.3.0.zip
output_line "Finished downloading and installing Improved Automatic Campaign Switcher (ACS) plugin for Sourcemod"

output_line "Adding Sourcemod admins..."
cat ${STEAMCMD_MOUNT}/sourcemod/admins_simple_lines.ini >> ${STEAMCMD_L4D2_SOURCEMOD_DIR}/configs/admins_simple.ini
output_line "Finished adding Sourcemod admins"

##################################################################################
#
# SOURCEMOD PROVISIONING (GAMEPLAY)
#
##################################################################################

# https://forums.alliedmods.net/showthread.php?p=1623308
output_line "Downloading and installing L4D & L4D2 Mutant Zombies gameplay plugin for Sourcemod..."
output_line "Version: 1.2.7 [19-Feb-2023]"
output_line "AlliedModders URL: https://forums.alliedmods.net/showthread.php?p=1623308"
wget ${DEPENDENCY_BASE_URL}/gameplay/sourcemod/l4d_mutant_zombies.zip
unzip l4d_mutant_zombies.zip -d l4d_mutant_zombies
mv l4d_mutant_zombies/addons/sourcemod/data/* ${STEAMCMD_L4D2_SOURCEMOD_DIR}/data
mv l4d_mutant_zombies/addons/sourcemod/plugins/* ${STEAMCMD_L4D2_SOURCEMOD_DIR}/plugins
mv l4d_mutant_zombies/addons/sourcemod/scripting/* ${STEAMCMD_L4D2_SOURCEMOD_DIR}/scripting
rm -rf l4d_mutant_zombies
rm l4d_mutant_zombies.zip
output_line "Finished downloading and installing L4D & L4D2 Mutant Zombies gameplay plugin for Sourcemod"

# https://forums.alliedmods.net/showthread.php?t=334655
output_line "Downloading and installing L4D & L4D2 Explosive Chains Credit gameplay plugin for Sourcemod..."
output_line "Version: 1.3 [26-Nov-2021]"
output_line "AlliedModders URL: https://forums.alliedmods.net/showthread.php?t=334655"
wget ${DEPENDENCY_BASE_URL}/gameplay/sourcemod/l4d_explosive_chains_credit.zip
unzip l4d_explosive_chains_credit.zip -d l4d_explosive_chains_credit
mv l4d_explosive_chains_credit/addons/sourcemod/plugins/* ${STEAMCMD_L4D2_SOURCEMOD_DIR}/plugins
mv l4d_explosive_chains_credit/addons/sourcemod/scripting/* ${STEAMCMD_L4D2_SOURCEMOD_DIR}/scripting
rm -rf l4d_explosive_chains_credit
rm l4d_explosive_chains_credit.zip
output_line "Finished downloading and installing L4D & L4D2 Explosive Chains Credit gameplay plugin for Sourcemod"

# https://forums.alliedmods.net/showthread.php?t=302140
output_line "Downloading and installing L4D & L4D2 Mutant Tanks gameplay plugin for Sourcemod..."
output_line "Version: 8.98 [10-Aug-2023]"
output_line "AlliedModders URL: https://forums.alliedmods.net/showthread.php?t=302140"
wget ${DEPENDENCY_BASE_URL}/gameplay/sourcemod/mutant_tanks-8.98.zip
unzip mutant_tanks-8.98.zip -d mutant_tanks
cp -r mutant_tanks/Mutant_Tanks-8.98/addons/sourcemod/data/* ${STEAMCMD_L4D2_SOURCEMOD_DIR}/data
mv mutant_tanks/Mutant_Tanks-8.98/addons/sourcemod/gamedata/* ${STEAMCMD_L4D2_SOURCEMOD_DIR}/gamedata
mv mutant_tanks/Mutant_Tanks-8.98/addons/sourcemod/mutant_tanks_updater.txt ${STEAMCMD_L4D2_SOURCEMOD_DIR}
cp -r mutant_tanks/Mutant_Tanks-8.98/addons/sourcemod/plugins/* ${STEAMCMD_L4D2_SOURCEMOD_DIR}/plugins
cp -r mutant_tanks/Mutant_Tanks-8.98/addons/sourcemod/scripting/* ${STEAMCMD_L4D2_SOURCEMOD_DIR}/scripting
cp -r mutant_tanks/Mutant_Tanks-8.98/addons/sourcemod/translations/* ${STEAMCMD_L4D2_SOURCEMOD_DIR}/translations
mv mutant_tanks/Mutant_Tanks-8.98/cfg/sourcemod/*.cfg ${STEAMCMD_L4D2_CFG_DIR}/sourcemod
rm -rf mutant_tanks
rm mutant_tanks-8.98.zip
output_line "Finished downloading and installing L4D & L4D2 Mutant Tanks gameplay plugin for Sourcemod"

##################################################################################
#
# SOURCE DEDICATED SERVER AND UTILITY SCRIPT PROVISIONING
#
##################################################################################

# https://github.com/SmartlyDressedGames/Unturned-3.x-Community/issues/2305#issuecomment-785075753
output_line "Making symlink to steamclient.so..."
mkdir -p ${STEAMCMD_HOME}/.steam/sdk32
ln -s ${STEAMCMD_HOME}/linux32/steamclient.so ${STEAMCMD_HOME}/.steam/sdk32/steamclient.so
output_line "Finished making symlink to steamclient.so"

output_line "Creating script to generate the L4D2 server.cfg file..."
cat <<SERVERCFGSCRIPT > ${STEAMCMD_HOME}/generate_l4d2_server_cfg.sh
#! /bin/bash

SERVER_TEMPLATE_DIR="${STEAMCMD_MOUNT}/srcds/cfg/server-cfg-template"
GENERATED_FILE="${L4D2_GENERATED_SERVER_CFG}"

# blank the ${L4D2_GENERATED_SERVER_CFG} file and then generate it
>\${GENERATED_FILE}
for filename in \${SERVER_TEMPLATE_DIR}/*.cfg
do
   cat \$filename | tr -d '\r' >> \${GENERATED_FILE}
   echo >> \${GENERATED_FILE}
   echo >> \${GENERATED_FILE}
done
SERVERCFGSCRIPT
chmod +x ${STEAMCMD_HOME}/generate_l4d2_server_cfg.sh
output_line "Finished creating script to generate the L4D2 server.cfg file"

output_line "Generating ${L4D2_GENERATED_SERVER_CFG} file..."
${STEAMCMD_HOME}/generate_l4d2_server_cfg.sh
output_line "Finished generating ${L4D2_GENERATED_SERVER_CFG} file"

output_line "Making symlink to L4D2 server.cfg file..."
ln -s ${L4D2_GENERATED_SERVER_CFG} ${STEAMCMD_L4D2_DIR}/left4dead2/cfg/server.cfg
output_line "Finished making symlink to server.cfg"

output_line "Creating Left 4 Dead 2 server startup script..."
echo "${STEAMCMD_L4D2_DIR}/srcds_run -console -game left4dead2 -port ${STEAMCMD_PORT} -maxplayers ${L4D2_SRCDS_MAX_PLAYERS} +maxplayers ${L4D2_SRCDS_MAX_PLAYERS} +exec server.cfg +map ${STEAMCMD_MAP_START}" > ${STEAMCMD_HOME}/start_l4d2.sh
chmod +x ${STEAMCMD_HOME}/start_l4d2.sh
output_line "Finished creating startup script"

output_line "Creating Left 4 Dead 2 server update script..."
echo "${STEAMCMD_HOME}/steamcmd.sh +runscript ${STEAMCMD_HOME}/steamcmd_update_l4d2.txt" > ${STEAMCMD_HOME}/update_l4d2.sh
chmod +x ${STEAMCMD_HOME}/update_l4d2.sh
output_line "Finished creating update script"

output_line "Finished Left 4 Dead 2 provisioning"