#set terminal postscript eps
set terminal postscript eps color
#set terminal postscript eps mono
set key inside right top vertical Right noreverse enhanced autotitles box linetype -1 linewidth 0.200
#set title "TD spectr" 
set ylabel "T, C" font "Helvetica-Bold,28"
set xlabel "Time, day" font "Helvetica-Bold,28"
set bars small
#set xrange [100:300]
#set yrange [0:]
set xrange [90:]
#set size 0.5,0.5
#set terminal postscript enhanced "Courier" 20

set terminal svg size 1800,1200 font "Helvetica,28"
set key autotitle columnhead
set datafile separator ";"
#set termoption dash

set style line 1 lt 1 lw 3 pt 6 linecolor rgb "red"
set style line 2 lt 2 lw 3 pt 7 linecolor rgb "blue"
set style line 3 lt 3 lw 3 pt 8 linecolor rgb "green"
set style line 4 lt 4 lw 3 pt 9 linecolor rgb "black"
set style line 5 lt 5 lw 3 pt 10 linecolor rgb "green"
set style line 6 lt 6 lw 3 pt 11 linecolor rgb "green"
set style line 7 lt 7 lw 3 pt 12 linecolor rgb "green"
set style line 8 lt 8 lw 3 pt 13 linecolor rgb "green"
set style line 9 lt 7 lw 3 pt 14 linecolor rgb "green"
set style line 10 lt 10 lw 3 pt 15 linecolor rgb "green"
set style line 11 lt 11 lw 3 pt 16 linecolor rgb "green"
set style line 12 lt 12 lw 3 pt 17 linecolor rgb "green"
set style line 13 lt 13 lw 3 pt 18 linecolor rgb "green"
set style line 14 lt 14 lw 3 pt 19 linecolor rgb "green"

set output "log-Q.svg"
set ylabel "Q, GJ (Q, kW/h /1000)" font "Helvetica-Bold,28"
plot "log.csv" using 1:2 with lines linestyle 1 ti "Q, GJ", \
 "log.csv" using 1:($2*0.278) with lines linestyle 2 ti "Q, kWh/1000"

set output "log-P.svg"
set ylabel "Q, GJ (Q, kW/h /1000)" font "Helvetica-Bold,12"
set ylabel "P, Watt" font "Helvetica-Bold,28"
plot "log.csv" using 1:3 with lines linestyle 1 ti "P storage, Watt", \
 "log.csv" using 1:4 with lines linestyle 2 ti "P Collector, Watt", \
 "log.csv" using 1:5 with lines linestyle 3 ti "P thermal load, Watt", \
 "log.csv" using 1:6 with lines linestyle 4 ti "P sum, Watt", \

set output "log-T.svg"
set ylabel "T, C" font "Helvetica-Bold,28"
plot "clog.csv" using 1:2 with lines linestyle 1 ti "T1", \
 "clog.csv" using 1:3 with lines linestyle 2 ti "T2", \
 "clog.csv" using 1:4 with lines linestyle 3 ti "T3", \
 "clog.csv" using 1:5 with lines linestyle 3 ti "T4", \
 "clog.csv" using 1:6 with lines linestyle 3 ti "T5", \
 "clog.csv" using 1:7 with lines linestyle 3 ti "T6", \
 "clog.csv" using 1:8 with lines linestyle 3 ti "T7"

set terminal canvas enhanced mousing rounded size 1500,500
set output "log.html"
set xlabel "Time, day" font "Helvetica-Bold,12"

set multiplot
set size 0.33,1.0
set grid

set origin 0.01,0.0
set title "Q" 
set ylabel "Q, GJ (Q, kW/h /1000)" font "Helvetica-Bold,12"
plot "log.csv" using 1:2 with lines linestyle 1 ti "Q, GJ", \
 "log.csv" using 1:($2*0.278) with lines linestyle 2 ti "Q, kW/h /1000"

set origin 0.34,0.0
set title "P" 
set ylabel "P, Watt" font "Helvetica-Bold,12"
#plot "log.csv" using 1:3 with lines linestyle 1 ti "Q, Watt", \
# "log.csv" using 1:4 with lines linestyle 2 ti "Collector, Watt"
plot "log.csv" using 1:3 with lines linestyle 1 ti "P storage, Watt", \
 "log.csv" using 1:4 with lines linestyle 2 ti "P Collector, Watt", \
 "log.csv" using 1:5 with lines linestyle 3 ti "P thermal load, Watt", \
 "log.csv" using 1:6 with lines linestyle 4 ti "P sum, Watt", \

set origin 0.67,0.0
set title "T" 
set ylabel "T, C" font "Helvetica-Bold,12"
plot "clog.csv" using 1:2 with lines linestyle 1 ti "T1", \
 "clog.csv" using 1:3 with lines linestyle 2 ti "T2", \
 "clog.csv" using 1:4 with lines linestyle 3 ti "T3", \
 "clog.csv" using 1:5 with lines linestyle 3 ti "T4", \
 "clog.csv" using 1:6 with lines linestyle 3 ti "T5", \
 "clog.csv" using 1:7 with lines linestyle 3 ti "T6", \
 "clog.csv" using 1:8 with lines linestyle 3 ti "T7"

unset multiplot

quit
