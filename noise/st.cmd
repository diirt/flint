#!/usr/bin/softIoc
dbLoadRecords("uniformNoise.db", "PREFIX=TST")
dbLoadRecords("fakeGaussianNoise.db", "PREFIX=TST")
iocInit
