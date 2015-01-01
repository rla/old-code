#include <iostream>
#include <stdlib.h>

/*
Ülesanne:
  leida vähim arv, mis jagub arvudega 1-20.
Lahendus:
  leiame arvu x, mis rahuldab järgmised tingimused
  1) iga arv jagub 1'ga, ei pea seda tingimust kontrollime x=1
  2) arv peab jaguma 2'ga => sisaldav algtegurit 2, x=2*a =2
  3) arv peab jaguma 3'ga => sisaldab algtegurit 3, x=3*2*a =6
  4) arv peab jagume 4'ga => x=3*2*2*a =12
  5) jaguvus 5'ga => x=5*3*2*2 =60
  6) jaguvus 6'ga, kui arv jagub 3 ja kahega, siis jagub ta 6'ga => x=5*3*2*2
  7) 7 on algarv => x=7*5*3*2*2
  8) jaguvus 8, siis arv sisaldab tegurit 8 => x=7*5*3*2*2*2
  9) jaguvus 9'ga, siis arv sisaldab tegurit 9 x=7*5*3*3*2*2*2
  10) jaguvus 10'ga, sisaldab tegurit 10 x=7*5*3*3*2*2*2
  11) 11 on algarv => x=11*7*5*3*3*2*2*2
  12) sisaldab tegurit 12, järelikult jagub 12'ga
  13) 13 on algarv => x=13*11*7*5*3*3*2*2*2
  14) 14, x sisaldab tegurit 14
  15) 15, x sisaldab tegurit 15
  16) 16, x peab sisaldab tegurit 16 => x=13*11*7*5*3*3*2*2*2*2
  17) 17 on algarv => x peab sisaldama tegurit 17 => x=17*13*11*7*5*3*3*2*2*2*2
  18) 18, x sisaldab tegurit 18, järelikult jagub 18'ga
  19) 19 on algarv => x=19*17*13*11*7*5*3*3*2*2*2*2
  20) x sisaldab tegurit 20 => x jagub 20'ga
*/

using namespace std;

int main(int argc, char *argv[])
{
  
  printf("x=%i\n", 19*17*13*11*7*5*3*3*2*2*2*2);
  system("PAUSE");	
  return 0;
}
