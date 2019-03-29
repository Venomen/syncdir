#!/bin/bash
#
#  Copyright (c) 2019 - Dawid Deręgowski - MIT
#
# Script to detect new files in directory
# And send changes to git repo
#
# PLEASE CHANGE $WATCH_DIR TO YOUR DIR!
# DEFAULT $TMP_DIR IS IN ROOT - if you change it,
# Rembember to edit last lines!
#
# SIMPLE SYNCDIR APP
# VERSION 1.0.0

source $HOME/scripts/syncdir/config


# Check if WATCH_DIR exists
if [ ! -d "$WATCH_DIR" ]; then
  echo "WATCH_DIR not found! Please check it." 1>&2
  exit 1
fi

# Check if tmp dir exists
if [ ! -d "$TMP_DIR" ]; then
  mkdir -p $TMP_DIR
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

## silent git mode
## for this script usage

s_git() {
    stdout=$(tempfile)
    stderr=$(tempfile)

    if ! git "$@" </dev/null >$stdout 2>$stderr; then
        cat $stderr >&2
        rm -f $stdout $stderr
        exit 1
    fi

    rm -f $stdout $stderr
}


## function for checking if in monitored directory there was some changes
## then pushing all to the repo

monitoring () {

  inotifywait -m -q -e modify --format %f ${WATCH_DIR} | while IFS= read -r file; sleep 1; do cp -p ${WATCH_DIR}/* ${TMP_DIR}/; cd $TMP_DIR ; s_git add . ; s_git commit -m "$file changed in ${WATCH_DIR}!" ; s_git push ; done
}

## checking if backup dir exists
## if not making new one
## and pulling from your repo
## if ok, using monitoring function

if [ "$(ls -A $TMP_DIR)" ] ; then
  echo "[$(date +"%d-%m-%Y %H:%M:%S")]: Running monitoring... To exit use CTRL+C / stop service."; monitoring;
else
  echo "Dir Empty! Clonning repo! Please write url for $(hostname) directory git repo:"; read url;

  ##
  ## IF YOU CHANGED $TMP_DIR, PLEASE CHANGE CD TARGET HERE!
  ##

  cd $SCRIPTS_DIR ; 
  s_git clone $url;
  echo "Ok, repo cloned. Running monitoring... To exit use CTRL+C."
  monitoring;
fi
