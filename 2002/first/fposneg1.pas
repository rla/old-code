program taisarvudelugeja;
uses crt;
                       {täisarvudest koosnemava faili toomine kuvarile}
  var ff:text;
      ff1:text;
      ff2:text;
     tarv:longint;
    fnimi:string[15];

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
assign(ff1,'fneg.art');
rewrite(ff1);
assign(ff2,'fpos.art');
rewrite(ff2);

ftarvekr('pro.and');
assign(ff,'pro.and');
reset(ff);
while not (eof(ff)) do
  begin
  readln(ff,tarv);
  if tarv>0 then writeln(ff2,tarv)
    else writeln(ff1,tarv);
  end;
close(ff1);
close(ff2);
writeln;
ftarvekr('fpos.art');
ftarvekr('fneg.art');
readln;
end.




