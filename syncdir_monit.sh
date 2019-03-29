#!/bin/bash

source $HOME/scripts/syncdir/config


SUBJECT="syncdir monitoring"

email () {
    echo "$DATA" | mail -s "$SUBJECT" "$ADDRESS"
}

check_syncdir () {
    ps -ef | awk '/syncdir.sh/ && !/awk/ {print}' | awk {'print $2'} | wc -l
}

kill_syncdir () {

  for pid in $(ps -efu root | grep root | grep syncdir.sh | grep -v grep | awk {'print $2'}); do kill -9 $pid; done;
  sleep 1;

}

start_syncdir () {
  
  /bin/bash $APP;

}

RESULT=$(check_syncdir)
DATA="Warning! syncdir @ $(hostname) has crashed, I've restarted it but please check!"

while true; do

  if [ $(check_syncdir) -lt 2 ]; then
      kill_syncdir
      email
      start_syncdir
  fi

  sleep 60;

done
