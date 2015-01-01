 program kolmekoh;
                 {kolmekohalise arvu ristsumma leidmine}
   var x,yh,km,sj:integer;
 begin
 writeln;
 writeln('ANNA KOLMEKOHALINE ARV');
 readln(X);
 sj:=x div 100;
 km:=x div 10 mod 10;
 yh:=x mod 10;
 writeln('Arvu ristsumma on ',sj+km+yh);
 readln;
 end.