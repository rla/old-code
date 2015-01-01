#include <iostream>
#include <stdlib.h>

/*
Ülesanne:
  leida pythagorase arvud a,b,c nii,et a+b+c=1000
Lahendus:
  pyhtagorase arvud peavad rahuldama tingimust a^2+b^2=c^2.
  esimesest tingimusest a=1000-b-c.
  muutes b ja c väärtusi, leiame a ja kontrollime pythagorase tingimust
  
Raivo Laanemets
*/

using namespace std;

int main(int argc, char *argv[])
{
  int a, b, c;
  bool leitud=false;
  
  for(b=1; b<=1000; b++) {
    for(c=b; c<=1000; c++) {
      a=1000-b-c;
      if(a*a+b*b==c*c) { leitud=true; break; }
    }
    if (leitud) break;
  }
  
  printf("a=%i\nb=%i\nc=%i\nabc=%i\n", a, b, c, a*b*c);
  
  system("PAUSE");	
  return 0;
}
