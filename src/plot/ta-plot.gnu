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
set xrange [0:]
#set size 0.5,0.5
#set terminal postscript enhanced "Courier" 20

set terminal svg size 1200,900 font "Helvetica,28"
set key autotitle columnhead
set datafile separator ";"
#set termoption dash

set style line 1 lt 1 lw 3 pt 6 linecolor rgb "red"
set style line 2 lt 2 lw 3 pt 7 linecolor rgb "blue"
set style line 3 lt 3 lw 3 pt 8 linecolor rgb "green"
set style line 4 lt 4 lw 3 pt 9 linecolor rgb "green"
set style line 5 lt 5 lw 3 pt 10 linecolor rgb "green"
set style line 6 lt 6 lw 3 pt 11 linecolor rgb "green"
set style line 7 lt 7 lw 3 pt 12 linecolor rgb "green"
set style line 8 lt 8 lw 3 pt 13 linecolor rgb "green"

set output "vta1-Q.svg"
set ylabel "Q, GJ (Q, kW/h /1000)" font "Helvetica-Bold,28"
plot "vta1.csv" using ($1*0.174):2 with lines linestyle 1 ti "Q, GJ", \
 "vta1.csv" using ($1*0.174):($2*0.278) with lines linestyle 2 ti "Q, kWh/1000"

set output "vta1-P.svg"
set ylabel "Q, GJ (Q, kW/h /1000)" font "Helvetica-Bold,12"
set ylabel "P, Watt" font "Helvetica-Bold,28"
plot "vta1.csv" using ($1*0.174):3 with lines linestyle 1 ti "Q, Watt"

set output "vta1-T.svg"
set ylabel "T, C" font "Helvetica-Bold,28"
plot "vta1.csv" using ($1*0.174):4 with lines linestyle 1 ti "T1", \
 "vta1.csv" using ($1*0.174):5 with lines linestyle 2 ti "T2", \
 "vta1.csv" using ($1*0.174):6 with lines linestyle 3 ti "T3", \
 "vta1.csv" using ($1*0.174):7 with lines linestyle 3 ti "T4", \
 "vta1.csv" using ($1*0.174):8 with lines linestyle 3 ti "T5", \
 "vta1.csv" using ($1*0.174):9 with lines linestyle 3 ti "T6", \
 "vta1.csv" using ($1*0.174):10 with lines linestyle 3 ti "T7", \
 "vta1.csv" using ($1*0.174):11 with lines linestyle 3 ti "T8", \
 "vta1.csv" using ($1*0.174):12 with lines linestyle 3 ti "T9"


set terminal canvas enhanced mousing rounded size 1500,500
set output "vta1.html"
set xlabel "Time, day" font "Helvetica-Bold,12"

set multiplot
set size 0.33,1.0
set grid

set origin 0.01,0.0
set title "Q" 
set ylabel "Q, GJ (Q, kW/h /1000)" font "Helvetica-Bold,12"
plot "vta1.csv" using ($1*0.174):2 with lines linestyle 1 ti "Q, GJ", \
 "vta1.csv" using ($1*0.174):($2*0.278) with lines linestyle 2 ti "Q, kW/h /1000"

set origin 0.34,0.0
set title "P" 
set ylabel "P, Watt" font "Helvetica-Bold,12"
plot "vta1.csv" using ($1*0.174):3 with lines linestyle 1 ti "Q, Watt"

set origin 0.67,0.0
set title "T" 
set ylabel "T, C" font "Helvetica-Bold,12"
plot "vta1.csv" using ($1*0.174):4 with lines linestyle 1 ti "T1", \
 "vta1.csv" using ($1*0.174):5 with lines linestyle 2 ti "T2", \
 "vta1.csv" using ($1*0.174):6 with lines linestyle 3 ti "T3", \
 "vta1.csv" using ($1*0.174):7 with lines linestyle 3 ti "T4", \
 "vta1.csv" using ($1*0.174):8 with lines linestyle 3 ti "T5", \
 "vta1.csv" using ($1*0.174):9 with lines linestyle 3 ti "T6", \
 "vta1.csv" using ($1*0.174):10 with lines linestyle 3 ti "T7", \
 "vta1.csv" using ($1*0.174):11 with lines linestyle 3 ti "T8", \
 "vta1.csv" using ($1*0.174):12 with lines linestyle 3 ti "T9"

unset multiplot


quit
