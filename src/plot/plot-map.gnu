
set terminal pngcairo  transparent enhanced font "arial,10" fontscale 1.0 size 1800,1200

unset key
#set view map scale 1
set view map
set style data lines
set xtics border in scale 0,0 mirror norotate  autojustify
set ytics border in scale 0,0 mirror norotate  autojustify
set ztics border in scale 0,0 nomirror norotate  autojustify
unset cbtics
set rtics axis in scale 0,0 nomirror norotate  autojustify
set title "Heat Map" 
set xrange [ -0.500000 : 200.50000 ] noreverse nowriteback
set yrange [ -0.500000 : 200.50000 ] noreverse nowriteback
set cbrange [ 0.00000 : 100.00000 ] noreverse nowriteback
set palette rgbformulae 33,13,10

set format cb "%3.0f"
set cbtics border in scale 0,0 mirror norotate  autojustify

set output "surf.png"
set multiplot
set size 0.33,0.5
set grid

set origin 0.0,0.0
set title "z=1" 
splot "surf-z1.csv" matrix with image

set origin 0.33,0.0
set title "z=2" 
splot "surf-z2.csv" matrix with image

set origin 0.66,0.0
set title "z=3" 
splot "surf-z3.csv" matrix with image

set xrange [ -0.500000 : 200.50000 ] noreverse nowriteback
set yrange [ -0.500000 : 200.50000 ] noreverse nowriteback

set origin 0.0,0.5
set title "y=1" 
splot "surf-y1.csv" matrix with image

set origin 0.33,0.5
set title "y=5" 
splot "surf-y5.csv" matrix with image

set origin 0.66,0.5
set title "y=10" 
splot "surf-y10.csv" matrix with image

unset multiplot

quit
