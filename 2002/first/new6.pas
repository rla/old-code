program new2;
             {}
uses crt;

  const uusfail='uus.art';

  var n:integer;
     ff,ff1:text;
     arv,a,b,min,min2:longint;
     fnimi:string;

procedure ftarvekr(fnimi:string);
    var arv:longint;
         ff:text;
  begin
  assign(ff,fnimi);
  reset(ff);
  writeln;
  writeln('Faili ',fnimi,' sisu:');
  while not (eof(ff)) do
    begin
    readln(ff,arv);
    write(arv:10);
    end;
  close(ff);
  writeln;
  end;{ftarvekr}

begin
clrscr;
write('Sisesta faili nimi : ');
readln(fnimi);
ftarvekr(fnimi);

assign(ff,fnimi);
reset(ff);

assign(ff1,uusfail);
rewrite(ff1);

close(ff1);
close(ff);
readln;
end.