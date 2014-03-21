#!/bin/bash
USER=`whoami`

if [ $USER != "root" ];
then
    echo "Server script must be run as root"
    exit -1
fi

BASEDIR=$(dirname $0)
cd $BASEDIR
./start-controller.sh

ETH="eth1"
while true; do
  COMMAND=`./wait-for-command.sh 2> /dev/null`
  case $COMMAND in
     start*) echo Executing \"$COMMAND\"
             NSEC=`echo $COMMAND | cut -d " " -f 3`
             IOC=`echo $COMMAND | cut -d " " -f 2`
             IOCDIR=`echo ../../flint-ca/$IOC`
             if [ -d "$IOCDIR" ]; then
                echo Stopping current IOC
                ./stop-ioc.sh &> /dev/null
                echo Waiting $NSEC seconds
                sleep $NSEC
                ./start-ioc.sh $IOC
             else
                echo IOC $IOC does not exist: skipping command
             fi
             ;;
     netpause*) echo Executing \"$COMMAND\"
             ./network-pause.sh $ETH `echo $COMMAND | cut -d " " -f 2`
             ;;
     connections*) echo Executing \"$COMMAND\"
             PV=`echo $COMMAND | cut -d " " -f 2`
             OUTPUT=`./channel-connections.sh $PV`
             caput output $OUTPUT &> /dev/null
             ;;
     stop*) echo Shutting down
             echo Stopping current IOC
             ./stop-ioc.sh &> /dev/null
             echo Done
             exit 0;
             ;;
     *) echo Unrecognized command $COMMAND
        ;;
  esac
  echo Ready for next command
  caput command ready &>/dev/null
done