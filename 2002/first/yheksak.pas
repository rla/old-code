 program yheksak;
                 {kontrolli kas üheksakordne kahekohaline arv võrdub arvuga,mis tekib
                 kui sisestatud arvu üheliste ja kümneliste numbrite vahele null}
   var arv:integer;
 begin
 writeln;
 writeln('Sisesta kahekohaline arv: ');
 readln(arv);
   if 9*arv=100*(arv div 10)+(arv mod 10) then writeln('Võrdub')
   else writeln('Ei võrdu');
 readln;
 end.