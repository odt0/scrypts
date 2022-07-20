#!/bin/bash
#
# mon run service
# Example: service_mon.sh [name service]

STATUS=`service $1 status | grep аctive`
DEAD=`service $1 status | grep dead`
RUNNING=`service $1 status | grep running`


if [ -n "$DEAD" ];
        then
          service $1 start
          echo "$(date "+%Y.%m.%d-%H.%M.%S") $DEAD. restart service" >> /var/log/$1_mon.log
          echo "$(date "+%Y.%m.%d-%H.%M.%S") WARNING! $1 $STATUS SERVICE START" >> /var/log/$1_mon.log

      elif [ -n "RUNNING" ];
        then
          echo "active"
      else
          echo "$(date "+%Y.%m.%d-%H.%M.%S") $STATUS" >> /var/log/$1_mon.log
          service $1 restart
          echo "$(date "+%Y.%m.%d-%H.%M.%S") WARNING! $1 $STATUS SERVICE RESTART" >> /var/log/$1_mon.log
fi

