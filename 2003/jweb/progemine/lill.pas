program lilled;
  uses crt;
  const fnimi='lill.is';
  type
        lillt = record
              nimi:string[10];
              varv:string[10];
              hind:real;
              end;
var
       ff:file of lillt;
      lill:lillt;
      ch:char;
      nimi,varv:string[10];
      hind:real;
      i:integer;
      lon:boolean;
      raha:real;
begin
repeat
clrscr;
writeln('LILLED':40);
writeln('<1> väljasta kõik');
writeln('<2> teatud summast suuremad');
writeln('<ESC> lahku');
writeln;
ch:=readkey;
case ch of
  '0':begin
      assign(ff,fnimi);
      rewrite(ff);
      repeat
      for i:=1 to 80*25 do write(' ');
      gotoXY(1,1);
      clrscr;
      writeln('lõpetamise tunnus lillenimi #');
      writeln('nimi');
      writeln('varv');
      writeln('hind');
      gotoXY(6,2); readln(lill.nimi);
      gotoXY(6,3); readln(lill.varv);
      gotoXY(6,4); readln(lill.hind);
      if lill.nimi<>'#' then write(ff,lill);
      until lill.nimi='#';
      close(ff);
      end;
  '1':begin
      writeln('LILLED');
      writeln;
      writeln;
      assign(ff,fnimi);
      reset(ff);
      i:=0;
      repeat
        begin
        seek(ff,i);
        read(ff,lill);
        write(lill.nimi:10);
        write(lill.varv:10);
        write(lill.hind:10:2); writeln(' kr.');
        inc(i);
        end;
      until i=filesize(ff);
      writeln;
      readln;
      close(ff);
      end;
  '2':begin
      write('Sisesta rahasumma(kr) : ');
      readln(raha);
      writeln;
      writeln('Lilled, mille hind on suurem : ');
      assign(ff,fnimi);
      reset(ff);
      writeln;
      lon:=false;
      i:=0;
      repeat
      seek(ff,i);
      read(ff,lill);
      if lill.hind>raha then
        begin
        write(lill.nimi:10);
        write(lill.varv:10);
        write(lill.hind:10:2); writeln(' kr.');
        lon:=true;
        end;
      inc(i);
      until i=filesize(ff);
      if not lon then writeln('Ei olegi');
      writeln;
      readln;
      close(ff);
      end;
end;
until ch=#27;
end.