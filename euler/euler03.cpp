#include <iostream>
#include <stdlib.h>

/*
Ülesanne:
  leida paaris fibonacci arvude summa, kui maksimaalne arvu väärtus on <1000000
Lahendus
  lihtne arvutamine
  
Raivo Laanemets
*/

using namespace std;

int main(int argc, char *argv[])
{

  int i=1, j=2, n, count=2, sum=2;
  //algsummale liidame 2, sest tsükkel algab kolmanda
  //arvu leidmisega
  
  while(n<1000000) {
    n=i+j;
    if(n%2==0) sum+=n;
    i=j;
    j=n;
  }
  
  printf("lõppvastus: %i\n", sum);
  
  system("PAUSE");	
  return 0;
}
