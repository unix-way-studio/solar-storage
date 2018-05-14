#!/bin/bash

mkdir -p trace
rm trace/*.csv
rm trace/*.png
h=6

./vta2-ti -o vta2.csv -tpi 0.01 \
-t 4,3.268,$h -t 5,3.268,$h -t 6,3.268,$h \
-t 3.5,4.134,$h -t 4.5,4.134,$h -t 5.5,4.134,$h -t 6.5,4.134,$h \
-t 3,5,$h -t 4,5,$h -t 5,5,$h -t 6,5,$h -t 7,5,$h \
-t 3.5,5.866,$h -t 4.5,5.899,$h -t 5.5,5.899,$h -t 6.5,5.899,$h \
-t 4,6.732,$h -t 5,6.732,$h -t 6,6.732,$h \
-c 5,5,1 -c 5,5,3 -c 5,5,5 -c 5,5,7 -c 5,5,9 -c 1,1,3 -c 2,2,3 -c 3,3,3 \
-isol 3:7 3:7 0.2:0.3 0.001 \
-isol 3:3.2 3:7 0:4 0.001 \
-isol 6.8:7 3:7 0:4 0.001 \
-isol 3:7 3:3.2 0:4 0.001
#gnuplot ta-plot.gnu
#gnuplot ta-plot-map.gnu
