#!/usr/bin/softIoc
dbLoadRecords("waveformCounters.db", "PREFIX=TST")
dbLoadRecords("square.db", "PREFIX=TST")
dbLoadRecords("sawtooth.db", "PREFIX=TST")
dbLoadRecords("triangle.db", "PREFIX=TST")
dbLoadRecords("sine.db", "PREFIX=TST")
dbLoadRecords("cosine.db", "PREFIX=TST")
iocInit
