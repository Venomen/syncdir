#!/bin/bash
#
# Lets copy some files...
# If you changed your source dir, please change also this 'root' below


# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Make sure that daemon is installed
if [ ! -f /usr/bin/daemon ]; then
   echo "Daemon not found! Please install daemon (apt-get install daemon)" 1>&2
   exit 1
fi

# Make sure that inotifywait is installed
if [ ! -f /usr/bin/inotifywait ]; then
  echo "inotifywait not found! Please install inotify-tools (apt-get install inotify-tools)" 1>&2
  exit 1
fi

# Make sure that git is installed
if [ ! -f /usr/bin/git ]; then
  echo "git client not found! Please install git" 1>&2
  exit 1
fi

# Installing app..
touch /var/log/syncdir_monit.info
touch /var/log/syncdir_monit.err
cp syncdirmonit /etc/init.d/
chmod +x /etc/init.d/syncdirmonit
/etc/init.d/syncdirmonit start

echo "end of syncdir install..."
echo ""
echo "syncdir enabled, monitoring enabled"

