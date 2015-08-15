#!/bin/bash

#########################
# Script - Dummy script #
#########################
#
# DO NOT MODIFY THIS FILE.
#
# This is a script example.
#

# Initialisation
#
# Here you can load constants files
# If applications are enabled, you can load specific configuration files, with:
# source $CURRENT_DIR/**your_project_short_name**Constants.sh
#
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $CURRENT_DIR'/init.sh'
source $CURRENT_DIR'/globalConstants.sh'
echo -e "\n\e[0;35m### Dummy script as an exemple - `date`\e[0m"

# Description
echo -e "\e[0;35m### Describe what it does… \e[0m"
echo "Execute commands here. You have access to multiple env variables in globalConstants.sh and other configuration files."
echo "This script is located in $CURRENT_DIR. Only users in the script group can see and execute this script."
echo "Logs are stored in $SCRIPT_LOGPATH. Only users in the script group can see those logs."
echo -e "\e[0;35m### done\e[0m"

# Action 2
echo -e "\e[0;35m### Dummy action 2… \e[0m"
echo "This script does nothing but print things on stdout."
echo -e "\e[0;35m### done\e[0m"

exit 0
