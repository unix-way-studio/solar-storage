#!/bin/bash

mkdir -p trace
rm trace/*.csv
rm trace/*.png
h=10

./solar-storage -o log.csv -oc clog.csv -tpi 0.01 -CollectorS 40 \
-t 4,5,$h -t 4,7.5,$h -t 4,10,$h \
-t 4,12.5,$h -t 4,15,$h -t 16,5,$h -t 16,7.5,$h \
-t 16,10,$h -t 16,12.5,$h -t 16,15,$h -t 5,4,$h -t 7.5,4,$h \
-t 10,4,$h -t 12.5,4,$h -t 15,4,$h -t 5,16,$h \
-t 7.5,16,$h -t 10,16,$h -t 12.5,16,$h -t 15,16,$h  \
-c 10,10,1 -c 5,5,1 -c 10,5,1 -c 10,10,5 -c 10,10,10 -c 4,4,1 -c 4,4,10  \
-isol 3.5:3.7 3.5:16.5 0:2 0.5 \
-isol 16.3:16.5 3.5:16.5 0:2 0.5 \
-isol 3.5:16.5 16.3:16.5 0:2 0.5 \
-isol 3.5:16.5 3.5:3.7 0:2 0.5 \
-isol 3.5:16.5 3.5:16.5 0:0.2 0.5
#gnuplot ta-plot.gnu
#gnuplot ta-plot-map.gnu
