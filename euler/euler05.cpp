#include <iostream>
#include <stdlib.h>

/*
Ülesanne:
  leida 10001. algarv alustades 2'st
Lahendus:
  proovime jõumeetodil
  
Raivo Laanemets
*/

using namespace std;

int main(int argc, char *argv[])
{
  
  int arv=3, b=3, k=1;
  bool algarv;
  
  do {
    b=3;
    algarv=true;
    while(b<=arv/2) {
      if(arv%b==0) algarv=false;
      b=b+2;
    }
    if(algarv) { k++; printf("%i\n", arv); }
    arv+=2;
    if(k%100==0) printf("%i\n", k/100);
  } while (k<10001);
  
  printf("10001. algarv on %i\n", arv-2); //NB viimase tsükli lõpus suurendati arvu 2 võrra!
  
  system("PAUSE");	
  return 0;
}
