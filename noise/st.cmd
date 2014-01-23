#!/usr/bin/softIoc
dbLoadRecords("uniformNoise.db", "PREFIX=TST")
dbLoadRecords("fakeGaussianNoise.db", "PREFIX=TST")
dbLoadRecords("gaussianNoise.db", "PREFIX=TST")
iocInit
