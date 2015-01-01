 program neljakoh;
          {kontrollib kas sisestatud neljakohalise arvu keskmised numbrid on sarnased}
   var arv:integer;
 begin
 writeln;
 writeln('Sisesta neljakohaline arv: ');
 readln(arv);
   if ((arv div 100) mod 10)=((arv div 10) mod 10) then writeln('Arvu keskmised numbrid on samad')
   else writeln('Arvu keskmised numbrid ei ole samad');
 readln;
 end.