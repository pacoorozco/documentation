# fs-cryptmount.sh

Mount a encFS (`$Encrypted_FS_Path`) into a directory (`$Mounting_Point_Path`). It will umount after some time (`$Idle_Timeout`). 

> I use Dropbox to keep a encFS with my personal information and I mount it into a local directory when it's needed. 

## Configuration
```
# Configuration variables
Encrypted_FS_Path=~/Dropbox/ENCRYPTED
Mounting_Point_Path=~/Private
# How many time (minutes) will a mounted filesystem be idle before umount
Idle_Timeout=10
```

## Usage
```
$ fs-cryptmount.sh -h
    Usage:

    fs-cryptmount.sh (v.0.0.4) [options]...
    Options:

    -h  Display this help message

    -u  Umount EncFS mounting point.

    Examples:

    $ fs-cryptmount.sh
    Minimal options. Will mount a specified EncFS into a specified mounting point.

    $ fs-cryptmount.sh -u
    Will umount the EncFS.
```

