 program arvnum;
   var x,yh,km,sj:integer;
 begin
 writeln;
 writeln('Anna kolmekohaline arv');
 readln(x);
 sj:=x div 100;
 km:=x div 10 mod 10;
 yh:=x-((x div 100)+(x div 10 mod 10));
 writeln('Sajalised ',sj);
 writeln('Kümnelised ',km);
 writeln('Ühelised ',yh);
 readln;
 end.