#!/bin/bash
USER=`whoami`

if [ $USER != "root" ];
then
    echo "Server script must be run as root"
    exit -1
fi

ETH="eth1"
while true; do
  COMMAND=`./wait-for-command.sh 2> /dev/null`
  case $COMMAND in
     start*) echo Executing \"$COMMAND\"
             NSEC=`echo $COMMAND | cut -d " " -f 3`
             IOC=`echo $COMMAND | cut -d " " -f 2`
             IOCDIR=`echo ../$IOC`
             if [ -n "$RUNNINGIOC" ]
             then
               /etc/init.d/softioc-$RUNNINGIOC stop
             fi
             echo Waiting $NSEC seconds
             sleep $NSEC
             /etc/init.d/softioc-$IOC start
             sleep 1
             RUNNINGIOC=$IOC
             ;;
     netpause*) echo Executing \"$COMMAND\"
             ./network-pause.sh $ETH `echo $COMMAND | cut -d " " -f 2`
             ;;
     stop*) echo Shutting down
             echo Stopping current IOC
             /etc/init.d/softioc-$RUNNINGIOC stop
             echo Done
             exit 0;
             ;;
     *) echo Unrecognized command $COMMAND
        ;;
  esac
  echo Ready for next command
  caput command ready &>/dev/null
done