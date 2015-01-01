program too14;
uses crt;
const fnimi='loom.is';
type loom=record
            nimi:string[8];
            vanus,kaal:byte;
            liik:string[8];
          end;


var  kodul:loom;
     top:byte;
     topl,liiktmp:string[8];
     nimi:string[8];
     vanus,i,kassid,koerad,hiired:byte;
     ch:char;
     ff:file of loom;
begin
ch:=#0;
repeat
clrscr;
writeln('KODULOOMAD(koer,kass,hiir)':40);
writeln;
writeln;
writeln('<1> väljasta kõik');
writeln('<2> väljasta loomad keda on kõige rohkem');
writeln('<3> väljasta kelle kaal on paarisarv');
writeln('<ESC> väljumine');
ch:=readkey;
case ch of
  '0':begin
      assign(ff,fnimi);
      rewrite(ff);
      repeat
      clrscr;
      write('Nimi : '); readln(kodul.nimi);
      write('Vanus : '); readln(kodul.vanus);
      write('Kaal : '); readln(kodul.kaal);
      write('Liik : '); readln(kodul.liik);
      if kodul.nimi<>'#' then write(ff,kodul);
      until kodul.nimi='#';
      close(ff);
      end;
  '1':begin
      clrscr;
      assign(ff,fnimi);
      reset(ff);
      i:=0;
      writeln('Nimi':8,'Vanus':8,'Kaal':8,'Liik':8);
      repeat
      seek(ff,i);
      read(ff,kodul);
      write(kodul.nimi:8);
      write(kodul.vanus:8);
      write(kodul.kaal:8);
      writeln(kodul.liik:8);
      inc(i);
      until i=filesize(ff);
      readln;
      close(ff);
      end;
  '2':begin
      clrscr;
      assign(ff,fnimi);
      reset(ff);
      i:=0;
      kassid:=0;
      koerad:=0;
      hiired:=0;
      top:=0;
      repeat
      seek(ff,i);
      read(ff,kodul);
      if kodul.liik='kass' then inc(kassid);
      if kodul.liik='koer' then inc(koerad);
      if kodul.liik='hiir' then inc(hiired);
      inc(i);
      until i=filesize(ff);
      reset(ff);
      if kassid>top then top:=kassid;
      if koerad>top then top:=koerad;
      if hiired>top then top:=hiired;
      write('Kõige rohkem on ');
      if hiired=top then begin writeln('hiiri'); topl:='hiir'; end;
      if koerad=top then begin writeln('koeri'); topl:='koer'; end;
      if kassid=top then begin writeln('kasse'); topl:='kass'; end;
      i:=0;
      writeln;
      writeln('Nimi':8,'Vanus':8,'Kaal':8,'Liik':8);
      repeat
      seek(ff,i);
      read(ff,kodul);
      if kodul.liik='koer' then
        begin
        write(kodul.nimi:8);
        write(kodul.vanus:8);
        write(kodul.kaal:8);
        writeln(kodul.liik:8);
        end;
      inc(i);
      until i=filesize(ff);
      readln;
      close(ff);
      end;
  '3':begin
      clrscr;
      writeln('LOOMAD, KELLE KAAL ON PAARISARV : ');
      writeln;
      writeln('Nimi':8,'Vanus':8,'Kaal':8,'Liik':8);
      assign(ff,fnimi);
      reset(ff);
      i:=0;
      repeat
      seek(ff,i);
      read(ff,kodul);
      if (kodul.kaal mod 2)=0 then
        begin
        write(kodul.nimi:8);
        write(kodul.vanus:8);
        write(kodul.kaal:8);
        writeln(kodul.liik:8);
        end;
      inc(i);
      until i=filesize(ff);
      readln;
      close(ff);
      end;
end;
until ch=#27;
end.