#!/bin/bash

##############################
# Cron script initialisation #
##############################

# Initialisation
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $CURRENT_DIR'/globalConstants.sh'
exec &> >(tee -a $SCRIPT_LOGPATH/`basename $0`.log)
