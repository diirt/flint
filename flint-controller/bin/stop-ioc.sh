#!/bin/bash
BASEDIR=$(dirname $0)
PID_NAME="softIoc.pid"
CURRENT_IOC="current-ioc"
cd $BASEDIR
source controller.cfg
cd $BASEDIR/../../flint-ca
case $IOC_START_METHOD in
  DIRECT) if [ ! -f $PID_NAME ]; then
             echo "No running process. Nothing to do"
          else
             ( echo exit || sleep 1) | telnet localhost $PROCSERV_PORT
             echo Waiting
             sleep 5
             kill `cat $PID_NAME`
             rm $PID_NAME
             rm $CURRENT_IOC
          fi
          ;;
  INITD) if [ ! -f $CURRENT_IOC ]; then
             echo "No running process. Nothing to do"
          else
             SOFTIOC_NAME=`cat $CURRENT_IOC`
             /etc/init.d/softioc-$SOFTIOC_NAME stop
             rm $PID_NAME
             rm $CURRENT_IOC
          fi
          ;;
  *) echo "Unrecognized IOC_START_METHOD"
     ;;
esac


