set terminal postscript eps color
set key inside right top vertical Right noreverse enhanced autotitles box linetype -1 linewidth 0.200
set bars small
#set yrange [0:6]
#set xrange [0:17532]
set xrange [0:17000]

set terminal svg size 17532,9000 font "Helvetica,28"
set key autotitle columnhead

set style line 1 lt 1 lw 3 pt 6 linecolor rgb "red"
set style line 2 lt 1 lw 10 pt 6 linecolor rgb "green"
set style line 3 lt 1 lw 3 pt 6 linecolor rgb "blue"
pi = 3.1415;

set output "cycle-P.svg"
#plot [0:17532] (3.05+2.43*sin(2*pi*x/8766-pi/2))*(0.5+0.5*sin(2*pi*x/24-pi/2)) points linestyle 2
plot 'cycle.dat' using 1:2 with lines ls 1, \
     'cycle.dat' using 1:3 with lines ls 2

set output "cycle-T.svg"
plot 'cycle.dat' using 1:4 with lines ls 2

quit
