# backupFilesOverSSH

It copies the specified folders (`$BACKUPDIRS`) to a remote host (`$RHOST`) via SSH.

## Configuration
```
# Define DIR to backup, separated by spaces.
BACKUPDIRS="/var/www" 

# Define destination server, user to backup
RHOST="ssh_hostname" # Hostname to copy file to.
RUSER="ssh_user"     # Username to access to the remote host.
ROPTIONS="-p 2201"   # Additional parameters to connect to the remote host.

# Define Remote PATHs to keep backup
CLIENTID="$(hostname -f)"
RBACKUPDIR="/home/paco/BACKUPS/${CLIENTID}/Files"
```

