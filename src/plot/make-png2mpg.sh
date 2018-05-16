#!/bin/bash

for si in {90..890}
do
 i=`printf "%05d" $si`
 if [ -f surf-$i.png ] ; then
  echo "Skip "surf-$i
 else
  if [ -f surf-y1-$i.csv ] ; then
   echo "Make "surf-$i
   cp surf-y1-$i.csv surf-y1.csv
   cp surf-y5-$i.csv surf-y5.csv
   cp surf-y9-$i.csv surf-y9.csv
   cp surf-z1-$i.csv surf-z1.csv
   cp surf-z2-$i.csv surf-z2.csv
   cp surf-z3-$i.csv surf-z3.csv
   gnuplot plot-map.gnu
   cp surf.png surf-$i.png
#  else
#   echo "Skip "surf-$i
  fi
 fi
done

rm surf-y1.csv
rm surf-y5.csv
rm surf-y9.csv
rm surf-z1.csv
rm surf-z2.csv
rm surf-z3.csv
rm surf.png

cd ..
gnuplot ta-plot.gnu
tail -n 10 vta2.csv
cd trace

#ffmpeg -y -i "surf-%05d.png" surf.mpg
#rm *.png

