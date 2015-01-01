program taisarvudelugeja;
uses crt;
                       {täisarvudest koosnemava faili toomine kuvarile}
  var ff:text;
      ff1:text;
      ff2:text;
    tarv:longint;
   fnimi:string[15];
begin
clrscr;
assign(ff1,'fneg.art');
rewrite(ff1);
assign(ff2,'fpos.art');
rewrite(ff2);
writeln('Sisesta faili nimi : ');
readln(fnimi);
writeln; writeln('Faili ',fnimi,' sisu:');
assign(ff,fnimi);
reset(ff);
while not (eof(ff)) do
  begin
  readln(ff,tarv);
  write(tarv:10);
  end;

reset(ff);
while not (eof(ff)) do
  begin
  readln(ff,tarv);
  if tarv>0 then writeln(ff2,tarv)
    else writeln(ff1,tarv);
  end;

writeln;
writeln('Tulemusfailide sisu : ');
reset(ff1);
reset(ff2);
writeln('Faili ','fpos.art',' sisu:');
while not (eof(ff2)) do
  begin
  readln(ff2,tarv);
  write(tarv:10);
  end;

writeln;
writeln('Faili ','fneg.art',' sisu:');
while not (eof(ff1)) do
  begin
  readln(ff1,tarv);
  write(tarv:10);
  end;

close(ff2);
close(ff1);
close(ff);
readln;
end.




