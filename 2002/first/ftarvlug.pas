program taisarvudelugeja;
                       {täisarvudest koosnemava faili toomine kuvarile}
  var ff:text;
    tarv:longint;
   fnimi:string[15];
begin
fnimi:='pro.and';
writeln; writeln('Faili ',fnimi,' sisu:'); writeln;
assign(ff,fnimi);
reset(ff);
while not (eof(ff)) do
begin
readln(ff,tarv);
write(tarv:10);
end;
close(ff);
readln;
end.




