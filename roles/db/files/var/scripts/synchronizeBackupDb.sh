#!/bin/bash

#########################
# Script - Sync backups #
#########################

# Initialisation
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $CURRENT_DIR'/init.sh'
source $CURRENT_DIR'/dbConstants.sh'
echo -e "\e[0;35m### Synchronize backups - `date`\e[0m"

# Sync on backup servers
for backupsDestination in ${BACKUPS_DESTINATIONS_DB[*]}; do
	echo -e "\e[0;35m### Synchronising datas on $backupsDestination… \e[0m"
	rsync --omit-dir-times -azv -u -P --exclude "*~" -e "ssh -o StrictHostKeyChecking=no -p $BACKUPS_PORT" "$BACKUPS_PATH/" $BACKUPS_USER@$backupsDestination:"$BACKUPS_PATH/"
	echo -e "\e[0;35m### done\e[0m"
done
