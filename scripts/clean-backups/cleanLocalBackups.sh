#!/bin/bash
#
# Script to make backups cleaning
#
# Author: Paco Orozco
# Date: 20100718

BCK_DIR=~/BACKUPS/
DAYS_TO_KEEP=5

NUM_OF_FILES=$(find ${BCK_DIR} -name "backup-*" -type f | wc -l)

if [ "${NUM_OF_FILES}" -gt "${DAYS_TO_KEEP}" ]; then
        find ${BCK_DIR} -name "backup-*" -a -ctime +${DAYS_TO_KEEP} -exec rm {} \;
fi
