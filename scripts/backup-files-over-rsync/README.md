# make_snapshot.sh

It does `rsync` snapshot from the specified folders (`$backup_sources`) to a destination folder (`$backup_destination_dir`), excluding the files that matches with the patterns file (`$exclude_patterns_file`). 

It keeps the last 3 copies to ensure optimal recovery.

## Configuration
```
# backup_sources: contains a list of folders to be backed up. They must be
# separated by spaces. If a folder doesn't exists a warning will be raised.
# e.g.: backup_sources="/home/dir1/ /home/dir2/"
backup_sources=""

# backup_destination_dir: contains an existent folder where backups will be
# kept. This is usually a mounted external disk.
# e.g.: backup_destination_dir=/mnt/backup_hd
backup_destination_dir=""

# exclude_patterns_file: contains a list of files and folders to be excluded from 
# backup. You can create a file with common exclusions using this command:
# wget https://raw.githubusercontent.com/rubo77/rsync-homedir-excludes/master/rsync-homedir-excludes.txt -O /tmp/ignorelist
# e.g.: Excludes_File=/tmp/ignorelist
exclude_patterns_file=""
```

## Usage
```
$ make_snapshot.sh -h      
      Usage:
  
      make_snapshot.sh -b source_folder -t destination_folder [options]...
  
      Options:
  
      -h  Display this help message
  
      -V  Show version information
  
      -v  number
      Set VERBOSITY level. Use 0 to 9, where default is 3
  
      -d  Enable debug information
  
      -q  Quiet
  
      -e  file
      This option specifies a FILE that contains exclude patterns (one per line). Blank lines in
      the file and lines starting with ’;’ or ’#’ are ignored. If FILE is -, the list will be
      read from standard input. It will use $HOME/.excludes_from_backup otherwise.
  
      -b  source_folder
      Mandatory. This is the path of folder to be backed up. You can use this option as many times
      as folders you want to back up.
  
      -t  destination_folder
      Mandatory. This is the path where snapshots will be kept.
  
      Examples:
  
      $ make_snapshot.sh -b /home/user1 -b /home/user2 -t /mnt/backup_hd
      Minimal options. Will backup /home/user1 and /home/user2 into /mnt/backup_hd
```

## How-to

### Backup
```
$ make_snapshot.sh -d -b /home/paco/ -b /home/public/web/ -t /media/paco/BACKUP_HD/BACKUP -e /home/paco/.excludes_from_backup
```

### Recover

You can browse the destination folder (e.g `/media/paco/BACKUP_HD/BACKUP`) and copy the files you need.
