#!/usr/bin/env bash
##########################################################################
# Shellscript:  Backup DBs to remote host via SSH
# Author     :  Paco Orozco <pakus@pakusland.net>
# Requires   :  mysql, mysqldump, ssh
# Category   :  System Administration
##########################################################################
# Changelog
# 20201107: 1.2
#       Fix shellcheck warnings.
# 201108: 1.1
#       Enable remote SCP copy of dumped DB
# 201008: 0.1
#       Inital release
##########################################################################

##########################################################################
# Configuration Section
##########################################################################
# Define DBs to backup, separated by spaces,
# if is set to null ALL DBs will be backed up.
DB_LIST=""

# List of DBs to be excluded, separed by spaces.
# This DBs will NOT be backed up.
DB_EXCLUDED="information_schema sys phpmyadmin performance_schema"

# Define DB host, user and pass, who can do mysqldump
DB_USER="root"
DB_HOST="localhost"

# Define destination server, user to backup
RHOST="ssh_hostname" # Hostname to copy file to.
RUSER="ssh_user"     # Username to access to the remote host.
ROPTIONS="-p 2201"   # Additional parameters to connect to the remote host.

# Define Remote PATHs to keep backup
CLIENTID=$(hostname -f)
RBACKUPDIR="/home/paco/BACKUPS/${CLIENTID}/DBs"

# Linux bin paths, change this if it can't be autodetected via which command
MYSQL="$(command -v mysql)"
MYSQLDUMP="$(command -v mysqldump)"
COMPRESS="$(command -v bzip2) -c"

##########################################################################
# DO NOT MODIFY BEYOND THIS LINE
##########################################################################
# Program name and version
PN=$(basename "$0")
VER='1.2'
# Get data in dd-mm-yyyy format
NOW="$(date +"%Y%m%d-%H%M")"
VERBOSE=0
##########################################################################
# Functions
##########################################################################
function usage {
        echo >&2 "${PN} - backup DBs on remote host via SSH, ${VER}
usage: ${PN} [-v]

        All configuration must be edited in ${PN}.
        -q: will be verbose.
        -h: this help."
        exit 1
}

function warn {
        if [ "${VERBOSE}" == "1" ]
        then
                if [ "$1" == "-n" ]
                then
                        shift; echo -n "$@"
                else
                        echo "$@"
                fi
        fi
}

function crit {
        local ERROR=0
        [ "$1" == "-e" ] && shift; ERROR=$1; shift
        echo >&2 "${PN}: $*"
        [ "${ERROR}" ] && exit "${ERROR}"
}
##########################################################################
# Main
##########################################################################
while [ $# -gt 0 ]
do
        case "$1" in
                # more flags here...
                -v)     VERBOSE=1;;
                -h)     usage;;
                -*)     usage;;
        esac
        shift
done

if [ -z "${DB_LIST}" ]
then
        # Get all database list first
        DB_LIST="$(${MYSQL} -u ${DB_USER} -h ${DB_HOST} -Bse 'show databases' | xargs)"
fi

if [ "${DB_EXCLUDED}" != "" ]
then
        for I in ${DB_EXCLUDED}
        do
                NEW_LIST=""
                for CURRENT_DB in ${DB_LIST}
                do
                        [ "${CURRENT_DB}" != "$I" ] && NEW_LIST="${NEW_LIST} ${CURRENT_DB}"
                done
                DB_LIST="${NEW_LIST}"
        done
fi

warn "Backup to:      ${RUSER}@${RHOST}"
warn "RemoteDir:      ${RBACKUPDIR}"
warn "DBs to backup:  ${DB_LIST}"
warn " "

for CURRENT_DB in ${DB_LIST}
do
        SKIPDB=-1
        if [ "${DB_EXCLUDED}" != "" ]
        then
                for I in ${DB_EXCLUDED}
                do
                        [ "${CURRENT_DB}" == "$I" ] && SKIPDB=1
                done
        fi

        if [ "${SKIPDB}" == "-1" ] ; then
                # File to store current backup file
                FILE="backup-${NOW}-DB-${CURRENT_DB}.bz2"
                RBACKUPFILE="${RBACKUPDIR}/${FILE}"

                # do all inone job in pipe,
                # connect to mysql using mysqldump for select mysql database
                # and pipe it out to gz file in backup dir
                warn -n "sending archive for ${CURRENT_DB}... "
                ssh ${ROPTIONS} ${RUSER}@${RHOST} "mkdir -p ${RBACKUPDIR}"
                if (${MYSQLDUMP} --opt --compress --single-transaction --user "${DB_USER}" -h ${DB_HOST} ${CURRENT_DB} | ${COMPRESS} | ssh ${ROPTIONS} ${RUSER}@${RHOST} "cat - >${RBACKUPFILE}")
                then
                    warn "created"
                else
                     warn "ERROR"
                fi
        fi
done
