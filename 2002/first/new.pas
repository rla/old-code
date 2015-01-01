program new;
uses crt;

  var
      arv:longint;
   ff,ffn:text;
    fnimi:string;
 i,ii,iii:integer;

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

assign(ffn,'fnew.art');
rewrite(ffn);

i:=0;
while not (eof(ff)) do
  begin
  readln(ff,arv);
  i:=i+1;
  end;

for ii:=i downto 1 do
  begin
  reset(ff);
  for iii:=1 to ii do
    readln(ff,arv);
  writeln(ffn,arv);
  end;

close(ffn);
ftarvekr('fnew.art');
close(ff);
readln;
end.