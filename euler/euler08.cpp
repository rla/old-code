#include <iostream>
#include <stdlib.h>

/*
Ülesanne:
  leida 317584931803 suurim algarvuline jagaja
*/

using namespace std;

int arv=3, b=3;
bool onalg;

int algarv() { //uue algarvu võtmine
  do {
    b=3;
    onalg=true;
    while(b<=sqrt(double(arv))) {
      if(arv%b==0) onalg=false;
        b=b+2;
      }
      arv+=2;
  } while(!onalg);
  return arv-2;
}

int main(int argc, char *argv[]) {

  double a=317584931803.0, eps=0.0001, j;
  long i, x;
  
  
  
  /*x=algarv();
  do {
    j=a/x;
    i=round(j);
    if (abs(j-i)<eps) printf("%i\n", x);
    x=algarv();
  } while(x<LONG_MAX-1000);
  /*
  
  
  printf("valmis");
  system("PAUSE");	
  return 0;
}
