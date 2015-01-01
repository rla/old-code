#include <iostream>
#include <stdlib.h>

using namespace std;

/*
Ülesanne:
  leida kõikide <1000 3 või 5'ga jaguvate arvude summa
  
Lahendus:
  leiame 3'ga ja 5'ga jaguvate arvude summa ning lahutame
  sellest 15'ga jaguvate arvude summa.
  
Raivo Laanemets
*/

int main(int argc, char *argv[])
{
  int n_3=0, n_5=0, n_15=0, sum=0;
  
  do {
    n_3+=3;
    sum+=n_3;
  } while(n_3<999);
  
  do {
    n_5+=5;
    sum+=n_5;
  } while(n_5<995);
  
  do {
    n_15+=15;
    sum-=n_15;
  } while(n_15<990);
  
  printf("n_3 väärtus: %i\n", n_3);
  printf("n_5 väärtus: %i\n", n_5);
  printf("n_15 väärtus: %i\n\n", n_15);
  printf("summa: %i\n", sum);
  
  system("Pause");
  return 0;
}
