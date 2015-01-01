program male1;

uses crt;

const n=8;

var x,y:array[1..8] of integer;
    laud:array[1..n, 1..n] of byte;
    i,j,algx,algy:byte;
    tpohi:boolean;
    cnt,sht:longint;

procedure kordi;
begin
inc(cnt);
if cnt>10000 then
  begin
  gotoxy(5,5);
  inc(sht);
  writeln('Kontrollitud(x10000) ',sht);
  cnt:=0;
  end;
end;{kordi}

procedure writelaud;
var k,l:byte;
begin
for k:=1 to n do
  for l:=1 to n do
  if l<n then write(laud[k,l]:3) else
    writeln(laud[k,l]:3);
end;

procedure ratsu(xx,yy,tase:integer; var t:boolean);
  var k:byte;
      newx,newy:integer;
      tt:boolean;
  begin
    kordi;
    tt:=false;
    t:=false;
    k:=1;
    if (tase<n*n) then
      repeat
        newx:=xx+x[k];
        newy:=yy+y[k];
        if (newx>0) and (newy>0) and (newx<=n) and (newy<=n) then
          begin
          laud[xx,yy]:=tase;
          if laud[newx,newy]>=tase then laud[newx,newy]:=0;
          if (laud[newx,newy]=0) then
            begin
            ratsu(newx, newy, tase+1, tt);
            if not(tt) then
              if laud[newx,newy]>=tase+1 then
                laud[newx,newy]:=0;
            end;
          end;
        if k=8 then laud[xx,yy]:=0;
        if tt then t:=true;
        k:=k+1;
      until (tt=true) or (k=9)
     else
       begin
         t:=true;
         laud[xx,yy]:=tase;
         writeln('-Laud leitud!-');
         writelaud;
         writeln('----');
       end;
  end;{ratsu}

begin
clrscr;
cnt:=1;
sht:=1;
for i:=1 to n do
  for j:=1 to n do
  laud[i,j]:=0;
writeln('MALE1');
x[1]:=1; y[1]:=2;
x[2]:=2; y[2]:=1;
x[3]:=1; y[3]:=-2;
x[4]:=2; y[4]:=-1;
x[5]:=-1; y[5]:=2;
x[6]:=-2; y[6]:=1;
x[7]:=-1; y[7]:=-2;
x[8]:=-2; y[8]:=-1;
write('Sisesta algx:'); readln(algx);
write('Sisesta algy:'); readln(algy);
if (algx>0) and (algy>0) and (n>0) then ratsu(algx,algy,1,tpohi);
if tpohi then writeln('Ratsu ok')
  else writeln('Käike ei leitud');
readln;
end.