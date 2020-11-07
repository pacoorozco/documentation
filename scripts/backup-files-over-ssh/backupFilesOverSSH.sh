#!/bin/bash
##########################################################################
# Shellscript:  Backup files to a remote server over SSH
# Author     :  Paco Orozco <pakus@pakusland.net>
# Requires   :  ssh
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
# Define DIR to backup, separated by spaces.
BACKUPDIRS="/var/www"

# Define destination server, user to backup
RHOST="ssh_hostname" # Hostname to copy file to.
RUSER="ssh_user"     # Username to access to the remote host.
ROPTIONS="-p 2201"   # Additional parameters to connect to the remote host.

# Define Remote PATHs to keep backup
CLIENTID="$(hostname -f)"
RBACKUPDIR="/home/paco/BACKUPS/${CLIENTID}/Files"

# Linux bin paths, change this if it can't be autodetected via which command
TAR="$(command -v tar)"

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
        echo >&2 "${PN} - backup DIRs on remote host via SSH, ${VER}
usage: ${PN} [-v]

        All configuration must be edited in ${PN}.
        -v: will be verbose.
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

if [ "${VERBOSE}" == "1" ]
then
        ERROR_FILE="&1"
else
        ERROR_FILE="/dev/null"
fi

if [ -z "${BACKUPDIRS}" ]
then
        # We need some DIRs to be backed up
        crit "You must supply some files to be backed up."
fi

warn "Backup to:      ${RUSER}@${RHOST}"
warn "RemoteDir:      ${RBACKUPDIR}"
warn "DIRs to backup:  ${BACKUPDIRS}"
warn " "

# File to store current backup file
FILE="backup-${NOW}.tgz"
RBACKUPFILE="${RBACKUPDIR}/${FILE}"

# do all inone job in pipe,
# connect to mysql using mysqldump for select mysql database
# and pipe it out to gz file in backup dir
warn -n "sending archive for ${BACKUPDIRS}... "
ssh ${ROPTIONS} $RUSER@$RHOST "mkdir -p ${RBACKUPDIR}"

if (${TAR} \
--gzip --create --absolute-names \
--file=- $BACKUPDIRS | ssh ${ROPTIONS} $RUSER@$RHOST "cat - >$RBACKUPFILE" ) 2>${ERROR_FILE}
then
  warn "created"
else
  warn "ERROR"
fi