program arvujada;
       {arvujada ümberpöörata,arvujada tsükliline nihutamine i kohta}
uses crt;

const n=9;
      jada:array[1..n] of integer = (2,-4,13,5,-7,21,14,3,-1);

var
      ch,chh:char;
      m,tmp,koh:integer;
      l,i:byte;
begin
repeat
clrscr;
writeln('<1> Pööra ümber');
writeln('<2> Nihuta i kohta');
writeln('<ESC> Väljumine');
ch:=readkey;
case ch of
  '1':begin
      clrscr;
      writeln('PÖÖRAB JADA ÜMBER':40);
      writeln;
      writeln;
      write('Esialgne');
      for i:=1 to n do write(jada[i]:4); writeln;
      write('Ümberpööratult');
      for i:=1 to (n div 2) do
        begin
        tmp:=jada[i];
        jada[i]:=jada[n-i+1];
        jada[n-i+1]:=tmp;
        end;
      for i:=1 to n do write(jada[i]:4); writeln;
      readln;
      end;
  '2':begin
      clrscr;
      writeln('NIHUTAB I KOHTA':40);
      writeln;
      writeln;
      write('Mitu kohta: '); readln(koh);
      write('Esialgne  ');
      for i:=1 to n do write(jada[i]:4); writeln;
      write('Nihutatult');
    if koh<0 then
    begin
    koh:=-koh;
      for l:=1 to koh do
        for i:=1 to n do
          begin
          if i=1 then tmp:=jada[i];
          if i<n then jada[i]:=jada[i+1]
            else jada[n]:=tmp;
          end;
    end
      else
      begin
      for l:=1 to koh do
        for i:=1 to n do
          begin
          if i=1 then tmp:=jada[n];
          if i<n then jada[n-i+1]:=jada[n-i];
          if i=n then jada[1]:=tmp;
          end;
      end;
      for i:=1 to n do write(jada[i]:4); writeln;
      chh:=readkey;
      end;
end;{case lõpp}
until ch=#27;
end.