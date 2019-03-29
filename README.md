Simple Syncdir App
==============


About
--------------
Just like name - simple app for syncing custom directory (for ex. /var/spool/cron/crontabs) with some git repo. Default WATCHDIR is <b>'/var/spool/cron/crontabs'</b>, you can change it to your custom directory in "config" file. Default app ROOT_DIR is <b>'/root/scripts/syncdir'</b>, you can also change it to yours, but remember - this app have to work as root. If you changed root app dir, also edit "source" parameter in "syncdir.sh" and "syncdir_monit.sh" files.

All other options like Mail address for notifications, you can edit in "config" file.

Install Package also has a init daemon script to monitor if app is working in background or not.

Requirements
--------------
Fedora / CentOS / RedHat:
- yum install epel-release
- yum install inotify-tools
- daemon for CentOS

Debian / Ubuntu:
- apt-get install inotify-tools
- apt-get install daemon

Installation
--------------
FIRST STEPS:

- check "config" file and make sure that all parameteres are ok
- prepare git repo for file archive (create directory, init/clone repo)
- create tmp directory for files monitoring (files will be copied there from source)
- run <b>syncdir.sh</b> to link synchro with your repo!

ADDITIONAL STEPS (instaling as system service):
1. If you don't need any custom changes just run <b>INSTALL.sh</b>
2. If you DON't want to use "/root/" directory, you have to changed it in "config" file before running INSTALL.sh
