# backupDBsOverSSH

It copies the specified mysql databases (`$DB_LIST`) to a remote host (`$RHOST`) via SSH.

## Configuration
```
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
```

