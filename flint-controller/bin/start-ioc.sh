#!/bin/bash
if [ ! "$#" -eq 1 ]; then
  echo "Usage: $0 <ioc_name>"
  echo "    $0 phase1"
  exit 1
fi

BASEDIR=$(dirname $0)
SOFTIOC_NAME=$1
cd $BASEDIR
source controller.cfg
case $IOC_START_METHOD in
  DIRECT) cd $BASEDIR/../../flint-ca/$SOFTIOC_NAME
          echo Starting IOC $SOFTIOC_NAME on $PORT from `pwd`
          procServ --noautorestart -p ../softIoc.pid $PROCSERV_PORT $SOFTIOC st.cmd
          ;;
  INITD) /etc/init.d/softioc-$SOFTIOC_NAME start
          ;;
  *) echo "Unrecognized IOC_START_METHOD"
     ;;
esac
echo $SOFTIOC_NAME > ../current-ioc
