#!/bin/bash

###########################
# Script - Save databases #
###########################

# Initialisation
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $CURRENT_DIR'/init.sh'
source $CURRENT_DIR'/dbConstants.sh'
echo -e "\e[0;35m### Save databases - `date`\e[0m"

for dbName in ${DATABASE_NAMES[*]}; do
  DUMPNAME="$DATABASE_DUMPNAME-$dbName"

  # Dump database
  echo -e "\e[0;35m### Saving database $dbName… \e[0m"
  mysqldump -u $DATABASE_USER -p$DATABASE_PASSWORD --port=$DATABASE_PORT $dbName > $DUMPNAME.sql
  echo -e "\e[0;35m### done\e[0m"

  # Compresse database dump
  echo -e "\e[0;35m### Compressing database dump $DUMPNAME.sql… \e[0m"
  tar -zcf $DUMPNAME.tar.gz $DUMPNAME.sql
  rm $DUMPNAME.sql
  echo -e "\e[0;35m### done\e[0m"

  # Copy dump in save folder
  echo -e "\e[0;35m### Copying database dump $DUMPNAME.tar.gz to backups folder $BACKUPS_PATH… \e[0m"
  mv $DUMPNAME.tar.gz $BACKUPS_PATH
  echo -e "\e[0;35m### done\e[0m"

done
