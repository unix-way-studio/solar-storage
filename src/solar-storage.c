#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define pi 3.1415
#define MaxS 10000

#define MaxA 200
#define MaxB 200
#define MaxC 200

FILE *in,*out,*outc,*fstat;

double CG=1520000.0, CV=1339.0, TEI=42500.0; // теплоемкость J/(K*M^3)
//double CG=800.0, CV=1030.0, TEI=1700.0; // теплоемкость J/(K*kG) грунта, воздуха, изоляции
double TPG=2.0, TPV=0.022, TPI=0.5; // теплопроводность грунта, воздуха, теплоизоляции
double TG0=10.0, TV0=20.0, TN=100.0; // температуры
double RG=1900, RV=1.3, RI=25; // плотность

double A=10.0, B=10.0, C=10.0; // размеры
double H=2.0, L=10.0, V=0.01; // параметры трубы
double l=0.1, S=0.01, V0=0.001; // размер, площадь грани и объем элем. ячейки
double dt=1.0; // шаг времени
double dL=2.0; // расстояние между трубами

double CollectorS=40; // площадь коллектора

double Q; // запасено в системе тепла
double Qp=0.0; // предидущее количество тепла

typedef struct
 {
  double T0; // начальная температура
  double T;  // текущая температура
  double dT; // изменение температуры
  double Cp; // теплоемкость
  double TPV; // теплопроводность
  double *nb1; // ссылка на температуру соседней ячейки
  double *nb2; // ссылка на температуру соседней ячейки
  double *nb3; // ссылка на температуру соседней ячейки
  double *nb4; // ссылка на температуру соседней ячейки
  double *nb5; // ссылка на температуру соседней ячейки
  double *nb6; // ссылка на температуру соседней ячейки
  double tb1; // средняя теплопроводность с соседней ячейкой
  double tb2; // средняя теплопроводность с соседней ячейкой
  double tb3; // средняя теплопроводность с соседней ячейкой
  double tb4; // средняя теплопроводность с соседней ячейкой
  double tb5; // средняя теплопроводность с соседней ячейкой
  double tb6; // средняя теплопроводность с соседней ячейкой
 } Cell;

Cell *m[MaxA][MaxB][MaxC];

typedef struct
 {
  double x;  // X координата трубы
  double y;  // Y координата трубы
  double z;  // глубина трубы
 } Tube;

typedef struct
 {
  double x;
  double y;
  double z;
 } Point;

typedef struct
 {
  double x1,x2;
  double y1,y2;
  double z1,z2;
  double Cp; // теплоемкость
  double TPV; // теплопроводность
 } Isol;

Tube mTube[100];
Point mc[100];
Isol mIsol[100];
long NTube=0, Nc=0, NIsol=0;

double SolarPower(double t) { return 3.6e6*(3.05+2.43*sin(2*pi*t/8766-pi/2))*(1+1*sin(2*pi*t/24-pi/2))/24; } // J*m^-2*hour

double TemperatureYear(double t) { return (-3.1+17.2*sin(2*pi*t/8766-pi/2))+(5+5*sin(2*pi*t/24-pi/2)); } // gradus C

double CollectorPower(double t) { // J*m^-2*hour
    double R,Pl,P;
    R=SolarPower(t);
    Pl=3600*3.1*(15-TemperatureYear(t));
    P=0;
    if(Pl<R) P=R-Pl;
    return P;
}

double ThermalLoad(double t) { // J*hour
    double Pl;
    Pl=3600*167*(TemperatureYear(t)-20);
    if(Pl<0) return Pl; else return 0;
}

int init_mT() {
 int x,y,z,i;
 double TPV;
 Cell *c;

 for(x=0;x<MaxA;x++)
  for(y=0;y<MaxB;y++)
   for(z=0;z<MaxC;z++) m[x][y][z] = (Cell *)malloc(sizeof(Cell));

 for(x=0;x<MaxA;x++)
  for(y=0;y<MaxB;y++)
   for(z=0;z<MaxC;z++) {
    m[x][y][z]->T0 = TG0;
    m[x][y][z]->T = TG0;
    m[x][y][z]->Cp = CG;
    m[x][y][z]->TPV = TPG;
   }

// теплоизоляция
 for(i=0;i<NIsol;i++) {
    for( x=mIsol[i].x1; x<=mIsol[i].x2; x++)
     for( y=mIsol[i].y1; y<=mIsol[i].y2; y++)
      for( z=mIsol[i].z1; z<=mIsol[i].z2; z++) m[x][y][z]->TPV = mIsol[i].TPV;
 }

// трубы
 for(i=0;i<NTube;i++) {
    x=mTube[i].x;z=mTube[i].z;
    for(y=0; y<MaxB; y++) { m[x][y][z]->TPV=TPV; m[x][y][z]->Cp=CG; }
//    for(y=0; y<MaxB; y++) { m[x][y][z]->TPV=TPV; m[x][y][z]->Cp=CG; m[x][y][z]->T=TG0; m[x][y][z]->T0=TG0; }
 }

// ссылки на соседние ячейки
 for(x=1;x<MaxA-1;x++)
  for(y=1;y<MaxB-1;y++)
   for(z=1;z<MaxC-1;z++) {
    c = m[x][y][z];
    c->nb1 = &(m[x-1][y][z]->T);
    c->nb2 = &(m[x+1][y][z]->T);
    c->nb3 = &(m[x][y-1][z]->T);
    c->nb4 = &(m[x][y+1][z]->T);
    c->nb5 = &(m[x][y][z-1]->T);
    c->nb6 = &(m[x][y][z+1]->T);
    TPV=m[x][y][z]->TPV;
    c->tb1 = (TPV + m[x-1][y][z]->TPV)/2;
    c->tb2 = (TPV + m[x+1][y][z]->TPV)/2;
    c->tb3 = (TPV + m[x][y-1][z]->TPV)/2;
    c->tb4 = (TPV + m[x][y+1][z]->TPV)/2;
    c->tb5 = (TPV + m[x][y][z-1]->TPV)/2;
    c->tb6 = (TPV + m[x][y][z+1]->TPV)/2;
   }
}

int eval() {
 Cell *c;
 long x,y,z;
 double T,Q;
// double k1=250.0*dt*S/l;
 double k1=240.0*dt*S/l;
// double k2=RG*V0/CG;
 double k2=1/V0;

 for(x=1;x<MaxA-1;x++)
  for(y=1;y<MaxB-1;y++)
   for(z=1;z<MaxC-1;z++) {
    c = m[x][y][z];
    T = c->T;
//    Q = k1*(*(c->nb1)+*(c->nb2)+*(c->nb3)+*(c->nb4)+*(c->nb5)+*(c->nb6)-T*6)*c->TPV;
    Q = k1*((*(c->nb1)-T)*c->tb1 + (*(c->nb2)-T)*c->tb2 + (*(c->nb3)-T)*c->tb3 + (*(c->nb4)-T)*c->tb4 + (*(c->nb5)-T)*c->tb5 + (*(c->nb6)-T)*c->tb6);
    c->dT = Q*k2/c->Cp;
//    if(x==50 && y==50 && z==50) printf("*** Q=%f dT=%f\n", Q, c->dT);
   }

 for(x=1;x<MaxA-1;x++)
  for(y=1;y<MaxB-1;y++)
   for(z=1;z<MaxC-1;z++) {m[x][y][z]->T += m[x][y][z]->dT; /*if(x==50 && y==50 && z==50) printf("*** T=%f dT=%f\n", m[x][y][z]->T, m[x][y][z]->dT);*/}
}

double eval_tube(long d, long h, double *SumQ1, double *SumQ2, double *SumQ) {
 Cell *c;
 long x,y,z,i,t;
 long SumT=0;
 double dQ1,dQ2,dT,dTsum=0;
 double k2=1/V0;

 t=d*24+h;
 for(i=0;i<NTube;i++) SumT+=mTube[i].z;
 dQ1=CollectorS*CollectorPower(t); // коллекторы
 dQ2=ThermalLoad(t); // нагрузка

 for(i=0;i<NTube;i++) {
    x=mTube[i].x;y=mTube[i].y;
//    for(y=MaxB;y>0;y--) m[x][y][z]->T = m[x][y-1][z]->T;
    for(z=1;z<mTube[i].z;z++) { dT = (dQ1+dQ2)*k2/(SumT*m[x][y][z]->Cp); m[x][y][z]->T += dT; dTsum+=dT; }
//    m[x][0][z]->T = Tx; 
 }
 printf("%ld  %ld  T=%.2f  dT=%.2f  Collector=%e  ThermalLoad=%e\n",d,h,TemperatureYear(t),dTsum/SumT,dQ1,dQ2);
 *SumQ1+=dQ1; *SumQ2+=dQ2; *SumQ+=dQ1+dQ2;
 return dQ1+dQ2;
}

void print_p(double a, double b, double c) {
 long x,y,z;

 x=a*10;y=b*10;z=c*10;
 fprintf(outc,"\t%.2f; ",m[x][y][z]->T);
 printf("\t%.2f ",m[x][y][z]->T);
}

void print_surf_y(double b, char *name, long i) {
 long x,y,z;
 FILE *f;
 char fname[4096];

 sprintf(fname,"trace/%s-%05ld.csv",name,i);
 f=fopen(fname,"w");
 y=b*10;
 for(z=MaxC-1;z>=0;z--) {
  for(x=0;x<MaxA;x++) fprintf(f,"%6.2f\t", m[x][y][z]->T);
   fprintf(f,"\n");
  }
 fclose(f);
}

void print_surf_z(double c, char *name, long i) {
 long x,y,z;
 FILE *f;
 char fname[4096];

 sprintf(fname,"trace/%s-%05ld.csv",name,i);
 f=fopen(fname,"w");
 z=c*10;
 for(x=MaxA-1;x>=0;x--) {
  for(y=0;y<MaxB;y++) fprintf(f,"%6.2f\t", m[x][y][z]->T);
   fprintf(f,"\n");
  }
 fclose(f);
}

void save_all(char *fname) {
 long x,y,z;
 FILE *f;

 f=fopen(fname,"w");
 for(x=0;x<MaxA;x++)
  for(y=0;y<MaxB;y++)
   for(z=0;z<MaxC;z++) fprintf(f,"%5.2f %5.2f %5.2f %6.2f\n", 0.1*x, 0.1*y, 0.1*z, m[x][y][z]->T);
 fclose(f);
}

double eval_q() {
 Cell *c;
 long x,y,z;
 double Qs;

 Qs=0.0;
 for(x=1;x<MaxA-1;x++)
  for(y=1;y<MaxB-1;y++)
   for(z=1;z<MaxC-1;z++) {
    c = m[x][y][z];
//    Qs += RG*V0*c->Cp*(c->T - c->T0);
    Qs += V0*c->Cp*(c->T - c->T0);
   }
 Q=Qs;
 return Qs;
}

void print_all(long i, double CollectorQ, double ThermalLoad, double dQsum) {
 long j;

 printf("%3ld \t%.3f ",i,Q/1.0e9);
 fprintf(out,"%3ld;\t %.3f; ",i,Q/1.0e9);

 printf("\t%.3f ",(Q-Qp)/86400.0);
 fprintf(out,"\t%.3f; ",(Q-Qp)/86400.0);

 printf("\t%.3f ",CollectorQ/86400.0);
 fprintf(out,"\t%.3f; ",CollectorQ/86400.0);

 printf("\t%.3f ",ThermalLoad/86400.0);
 fprintf(out,"\t%.3f; ",ThermalLoad/86400.0);

 printf("\t%.3f ",dQsum/86400.0);
 fprintf(out,"\t%.3f; ",dQsum/86400.0);

 Qp=Q;

 fprintf(outc,"%3ld; ",i);
 for(j=0; j<Nc; j++) print_p(mc[j].x, mc[j].y, mc[j].z);

 printf("\n");
 fprintf(out,"\n");
 fprintf(outc,"\n");
 fflush(out);
 fflush(outc);

 print_surf_y(1.0,"surf-y1",i);
 print_surf_y(5.0,"surf-y5",i);
 print_surf_y(9.0,"surf-y9",i);

 print_surf_z(1.0,"surf-z1",i);
 print_surf_z(2.0,"surf-z2",i);
 print_surf_z(3.0,"surf-z3",i);
}

int ReadConf(char *Name) {
    char fname[4096];
    
//Dimension: 20:20:20
//Vertical-Tube: 4,5,10
//Isolation: 3.5:3.7 3.5:16.5 0:2 0.5

}

int main(int argc, char *argv[])
{
 long i,j,d,n;
 double SumQ,SumQ1,SumQ2;
 double Q1=0.0;
 double Q2=0.0;
 double Q3=0.0;
 double Q4=0.0;
 double Q5=0.0;
 float tx,ty,tz,tx2,ty2,tz2,tp;

 out=stdout;in=stdin;
 NTube=0;Nc=0;
 for(i=1;i<argc;i++) {
    if(strcmp(argv[i],"-n")==0) {n=atol(argv[i+1]);i++;continue;}
    if(strcmp(argv[i],"-t")==0) {
	sscanf(argv[i+1],"%f,%f,%f",&tx,&ty,&tz); 
	mTube[NTube].x=tx*10.0;
	mTube[NTube].y=ty*10.0;
	mTube[NTube].z=tz*10.0;
	NTube++;
	i++;
	continue;
    } // трубы
    if(strcmp(argv[i],"-c")==0) {
	sscanf(argv[i+1],"%f,%f,%f",&tx,&ty,&tz);
	mc[Nc].x=tx;
	mc[Nc].y=ty;
	mc[Nc].z=tz;
	Nc++;
	i++;
	continue;
    } // контрольные точки
    if(strcmp(argv[i],"-isol")==0) {
	sscanf(argv[i+1],"%f:%f",&tx,&tx2);
	mIsol[NIsol].x1=tx*10; mIsol[NIsol].x2=tx2*10;
	sscanf(argv[i+2],"%f:%f",&ty,&ty2);
	mIsol[NIsol].y1=ty*10; mIsol[NIsol].y2=ty2*10;
	sscanf(argv[i+3],"%f:%f",&tz,&tz2);
	mIsol[NIsol].z1=tz*10; mIsol[NIsol].z2=tz2*10;
	sscanf(argv[i+4],"%f",&tp);
	mIsol[NIsol].TPV=tp;
	NIsol++;
	//printf("ni=%d  %f:%f %f:%f %f:%f  %f\n",NIsol, tx,tx2, ty,ty2, tz,tz2, tp);
	i+=4;
	continue;
    } // теплоизоляция
    if(strcmp(argv[i],"-tpi")==0) {TPI=atof(argv[i+1]);i++;continue;}
    if(strcmp(argv[i],"-tei")==0) {TEI=atof(argv[i+1]);i++;continue;}
    if(strcmp(argv[i],"-CollectorS")==0) {CollectorS=atof(argv[i+1]);i++;continue;}
    if(strcmp(argv[i],"-i")==0) {in=fopen(argv[i+1],"r");i++;continue;}
    if(strcmp(argv[i],"-o")==0) {out=fopen(argv[i+1],"w");i++;continue;}
    if(strcmp(argv[i],"-oc")==0) {outc=fopen(argv[i+1],"w");i++;continue;}
//   if(strcmp(argv[i],"-l")==0) {log=fopen(argv[i+1],"w");i++;continue;}
  }

 for(i=0;i<NTube;i++) printf("Tube %ld: %f %f %f\n",i+1, mTube[i].x, mTube[i].y, mTube[i].z);
 for(i=0;i<Nc;i++) printf("Control point %ld: %f %f %f\n",i+1, mc[i].x, mc[i].y, mc[i].z);
 for(i=0;i<NIsol;i++) printf("Isol%ld   %f:%f  %f:%f  %f:%f  %f\n",i+1, mIsol[i].x1,mIsol[i].x2, mIsol[i].y1,mIsol[i].y2, mIsol[i].z1,mIsol[i].z2, mIsol[i].TPV);

 init_mT();Qp=0.0;

 for(d=90;d<1945;d++) { // 5 year
    SumQ1=0;SumQ2=0;SumQ=0;
    for(i=0;i<24;i++) { // hour
	for(j=0;j<15;j++) eval();
	eval_tube(d,i,&SumQ1,&SumQ2,&SumQ);
    }
    eval_q();
    print_all(d,SumQ1,SumQ2,SumQ);
  }

// save_all("all-mt.csv");
/*
 fstat=fopen("vta2-stat.txt","w");
 fprintf(fstat,"Q1 = %.0f\n",Q1);
 fprintf(fstat,"Q2 = %.0f\n",Q2);
 fprintf(fstat,"Q3 = %.0f\n",Q3);
 fprintf(fstat,"Q4 = %.0f\n",Q4);
 fprintf(fstat,"Q5 = %.0f\n",Q5);
 fprintf(fstat,"Qsr1 = %.0f%%\n",100.0*(Q1-Q2)/Q1);
 fprintf(fstat,"Qw   = %.0f%%\n",100.0*(Q2-Q3)/Q1);
 fprintf(fstat,"Qsr2 = %.0f%%\n",100.0*(Q3-Q4)/Q1);
 fprintf(fstat,"Qost = %.0f%%\n",100.0*Q4/Q1);
 fclose(fstat);
*/
 fclose(in);
 fclose(out);
 fclose(outc);
}
