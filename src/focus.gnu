set terminal postscript eps color
set key inside right top vertical Right noreverse enhanced autotitles box linetype -1 linewidth 0.200
set bars small
set yrange [0:100]
set xrange [-50:50]

set terminal svg size 900,900 font "Helvetica,28"
set key autotitle columnhead

set style line 1 lt 1 lw 3 pt 6 linecolor rgb "red"
set style line 2 lt 1 lw 3 pt 6 linecolor rgb "green"
set style line 3 lt 1 lw 3 pt 6 linecolor rgb "blue"

set output "focus.svg"
set label "." at 0,15 center font "Helvetica,20" tc "red"
set label "." at 0,20 center font "Helvetica,20" tc "green"
set label "." at 0,25 center font "Helvetica,20" tc "blue"
#set label "F" at 0,23 center font "Helvetica,20"
plot x*x/(4*15) linestyle 1, \
  x*x/(4*20) linestyle 2, \
  x*x/(4*25) linestyle 3

quit
