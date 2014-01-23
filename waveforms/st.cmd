#!/usr/bin/softIoc
dbLoadRecords("waveformCounters.db", "PREFIX=TST")
dbLoadRecords("square.db", "PREFIX=TST")
dbLoadRecords("sawtooth.db", "PREFIX=TST")
iocInit
