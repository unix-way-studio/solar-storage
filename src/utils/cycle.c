#include <stdio.h>
#include <math.h>

#define pi 3.1415

int main() {
    double t,R,P,Pl,T,SumR,SumP;

    SumR=0;SumP=0;
    for( t=0.0; t<17533.0; t+=1.0 ) {
        R=3.6e6*(3.05+2.43*sin(2*pi*t/8766-pi/2))*(1+1*sin(2*pi*t/24-pi/2))/24; // J*m^-2
        T=(-3.1+17.2*sin(2*pi*t/8766-pi/2))+(5+5*sin(2*pi*t/24-pi/2));
	Pl=3600*3.1*(25-T);
	P=0;
	if(Pl<R) P=R-Pl;
	SumP+=P; SumR+=R;
	printf("%6.0f %e %e %5.2f\n", t, R, P, T );
    }
 fprintf(stderr,"w=%f\n",SumP/SumR);
}
