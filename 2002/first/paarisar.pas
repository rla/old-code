 program paarisar;
                  {näitab kas arv on paarisarv või paariyu arv}
   var arv:integer;
 begin
 writeln;
 write('Arv: ');
 readln(arv);
 if arv mod 2=0 then writeln('Arv on paarisarv') else writeln('Arv on paaritu');
 readln;
 end.
