## Latest version
Date: 20180806

```
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 18.04.1 LTS
Release:        18.04
Codename:       bionic
```

## System

Partition schema, mounted filesystems. All of them are `ext4`
```
$ sudo sfdisk -l
Disk /dev/nvme0n1: 477 GiB, 512110190592 bytes, 1000215216 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt

Device             Start       End   Sectors   Size Type
/dev/nvme0n1p1      2048   1026047   1024000   500M EFI System
/dev/nvme0n1p2   1026048   2050047   1024000   500M Linux filesystem
/dev/nvme0n1p3   2050048 130050047 128000000    61G Linux filesystem
/dev/nvme0n1p4 130050048 194050047  64000000  30,5G Linux swap
/dev/nvme0n1p5 194050048 980682751 786632704 375,1G Linux filesystem
```

Mount points are like these:
```
$ df -kh
Filesystem      Size  Used Avail Use% Mounted on
/dev/nvme0n1p3   60G  4,8G   52G   9% /
/dev/nvme0n1p2  477M   77M  371M  18% /boot
/dev/nvme0n1p5  369G  546M  349G   1% /home
/dev/nvme0n1p1  496M   81M  416M  17% /boot/efi
```

Tune a proper swappiness value for a laptop:
```
$ cat /proc/sys/vm/swappiness 
60
```

Edit `/etc/sysctl.conf` and put:
```
# Pakus - Change swappines to a more acurate value for desktop
vm.swappiness = 10
```

Edit `sudoers` and put umask override:
```
Defaults umask_override
```

Install some packages

```
sudo apt install build-essential
sudo apt install git
```

## Aplicacions

### Mask
Configure proper mask
```
$ umask 077
```

### Dropbox:
```
sudo apt install python-gpg
```
Note that the package `python-gpgme`, which is used by Dropbox to verify binary signature, is no longer in Ubuntu 18.04 repository. The successor is `python-gpg`.

Use the official provided Ubuntu package from [Dropbox website](https://www.dropbox.com/install-linux).

Once you have installed Dropbox, use "Selective sync" to sync only desired folders.

In order to use personal folders, I must put:

```
$ cd ~
$ mkdir Private
$ ln -sf Dropbox/PROJECTES
$ rmdir Documents
$ ln -sf Dropbox/Documents
```

In order to use the encrypted folder we must use EncFS, so we need to install it:
```
$ sudo apt install encfs
```

Then we can use [Munta_Dropbox_encriptat]() to use encrypted folder.

### Recover files

Copy files from BACKUP_HD
```
$ cp -apr /media/paco/BACKUP_HD/BACKUP/backup.0/PACO/.gnupg ~/.
$ cp -apr /media/paco/BACKUP_HD/BACKUP/backup.0/PACO/.ssh ~/.
```

Install dotfiles

```
$ git clone https://github.com/pacoorozco/dotfiles.git ~/.dotfiles
```

### pass
Install pass and password-store
```
$ sudo apt install pass
$ git clone git@bitbucket.org:pacoorozco/pass-repo.git .password-store
```

### Telegram

```
$ sudo snap install telegram-desktop
```

### Intelij IDEA Ultimate

```
$ sudo snap install intellij-idea-ultimate --classic --edge
```

### Spotify

Follow [the official installation guide](https://www.spotify.com/es/download/linux/), ultimately they recommend to use spotify as an snappy:

```
$ sudo snap install spotify
```

### Kwave Sound editor

A better alternative to Audacity
```
$ apt install kwave
```

### Virtualbox

Follow [official installation guide](https://www.virtualbox.org/wiki/Linux_Downloads)
```
$ echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -s -c) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list 
$ wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
$ sudo apt update
$ sudo apt install virtualbox-5.2
$ sudo apt install dkms
```

### GIMP
```
$ sudo snap install gimp
```

### Chrome

Download the package from its [official repository](https://www.google.es/chrome/browser/desktop/index.html) and do:
```
$ sudo dpkg -i google-chrome-stable_current_amd64.deb
$ apt -f install
```

### Pwgen
 
It is a command line utility to generate a block of random passwords.
```
$ sudo apt-get install pwgen
```
   
### Docker

From [here](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
```
$ sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
$ sudo apt-get update
$ sudo apt-get install docker-ce
$ sudo docker run hello-world
$ sudo usermod -aG docker $USER
$ sudo apt install docker-compose
```

### Enable hibernation

```
$ tail /etc/fstab
# swap was on /dev/nvme0n1p4 during installation
UUID=04244966-2fc4-4671-8996-05f372e136db none            swap    sw              0       0
```

Edit `/etc/default/grub` and add to `GRUB_CMDLINE_DEFAULT=resume=UUID=04244966-2fc4-4671-8996-05f372e136db`

```
$ sudo update-grub
```

Reboot and test it
``` 
$ sudo systemctl hibernate
```