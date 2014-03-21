#!/bin/bash
if [ ! "$#" -eq 0 ]; then
  echo "Usage: $0"
  exit 1
fi

BASEDIR=$(dirname $0)
SOFTIOC_NAME=$1
cd $BASEDIR
source controller.cfg
case $IOC_START_METHOD in
  DIRECT) cd $BASEDIR/../control
          PID_NAME="../softIoc.pid"
          if [ ! -f $PID_NAME ]; then
            echo Starting controller IOC $PROCSERV_CONTROLLER_PORT from `pwd`
            procServ --noautorestart -p ../softIoc.pid $PROCSERV_CONTROLLER_PORT $SOFTIOC st.cmd
          else
            echo Controller is already running
          fi
          ;;
  INITD) /etc/init.d/softioc-controller start
          ;;
  *) echo "Unrecognized IOC_START_METHOD"
     ;;
esac

