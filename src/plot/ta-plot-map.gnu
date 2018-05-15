
set terminal pngcairo  transparent enhanced font "arial,10" fontscale 1.0 size 800,800 

unset key
set view map scale 1
set style data lines
set xtics border in scale 0,0 mirror norotate  autojustify
set ytics border in scale 0,0 mirror norotate  autojustify
set ztics border in scale 0,0 nomirror norotate  autojustify
unset cbtics
set rtics axis in scale 0,0 nomirror norotate  autojustify
set title "Heat Map" 
set xrange [ -0.500000 : 100.50000 ] noreverse nowriteback
set yrange [ -0.500000 : 100.50000 ] noreverse nowriteback
#set cblabel "Score" 
set cbrange [ 0.00000 : 100.00000 ] noreverse nowriteback
set palette rgbformulae 33,13,10
#DEBUG_TERM_HTIC = 119
#DEBUG_TERM_VTIC = 119

#set colorbox user
#set colorbox vertical origin screen 0.9, 0.2 size screen 0.03, 0.6 front  noinvert noborder
set format cb "%3.0f"
set cbtics border in scale 0,0 mirror norotate  autojustify

set xrange [ -0.500000 : 100.50000 ] noreverse nowriteback
set yrange [ -0.500000 : 100.50000 ] noreverse nowriteback
set output "surf-y1.png"
splot "surf-y1.csv" matrix with image

set output "surf-y5.png"
splot "surf-y5.csv" matrix with image

set output "surf-y9.png"
splot "surf-y9.csv" matrix with image

set xrange [ -0.500000 : 100.50000 ] noreverse nowriteback
set yrange [ -0.500000 : 100.50000 ] noreverse nowriteback

set output "surf-z2.png"
splot "surf-z2.csv" matrix with image

#set cbrange [ 0.00000 : 60.00000 ] noreverse nowriteback
set output "surf-z1.png"
splot "surf-z1.csv" matrix with image

set output "surf-z3.png"
splot "surf-z3.csv" matrix with image

set terminal canvas enhanced mousing rounded size 800,600
#set xlabel 'Time'
#set ylabel 'Energy'
#set output "output.html"
#plot sin(4*x)/x with lines linewidth 2


set terminal canvas enhanced mousing rounded size 1200,800
set output "surf.html"

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

set xrange [ -0.500000 : 100.50000 ] noreverse nowriteback
set yrange [ -0.500000 : 100.50000 ] noreverse nowriteback

set origin 0.0,0.5
set title "y=1" 
splot "surf-y1.csv" matrix with image

set origin 0.33,0.5
set title "y=5" 
splot "surf-y5.csv" matrix with image

set origin 0.66,0.5
set title "y=9" 
splot "surf-y9.csv" matrix with image

unset multiplot

quit
