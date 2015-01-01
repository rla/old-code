 program absoluut;
                  {arvu absoluutväärtuse leimine}
   var x:integer;
 begin
 writeln;
 write('Arv: ');
 readln(x);
 if x>=0 then writeln('Arvu absoluutväärtus on ',x);
 if x<0 then writeln('Arvu absoluutväärtus on ',-x);
 readln;
 end.