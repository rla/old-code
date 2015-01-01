#include <iostream>
#include <stdlib.h>

/*
Ülesanne:
  leida (1+2+..+100)^2-(1^2+2^2+..+100^2)
Lahendus:
  lihtne arvutamine

Raivo Laanemets
*/

using namespace std;

int main(int argc, char *argv[])
{
  int i, r_sum=0, sum_i=0;
  
  for(i=1; i<=100; i++) {
    r_sum+=i*i;
    sum_i+=i;
  }
  
  
  printf("ruutude summa on %i\n", r_sum);
  printf("arvude summa on %i\n", sum_i);
  printf("lõppvastus on %i\n", sum_i*sum_i -r_sum);
  
  
  system("PAUSE");
  return 0;
}
