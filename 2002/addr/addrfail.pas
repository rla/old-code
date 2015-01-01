unit addrfail;
interface
uses crt;

procedure MenyOsa(lause:string);
procedure VarvOsa(lause,osa:string);
function DelKorduvad(vfail:string) :string;
procedure DelEkraan;
function RidadeArv(fnimi:string) :integer;
procedure Otsing(fnimi:string);
function GetFText(fnimi:string; mitm:integer) :string;
procedure KirTextSetF(fnimi:string; mitm:integer; setting:string);

implementation

procedure KirTextSetF(fnimi:string; mitm:integer; setting:string);
    var ff,fftmp:text;
         i:integer;
         rida:string;
  begin
  assign(ff,fnimi);
  reset(ff);
  assign(fftmp,'settings.tmp');
  rewrite(fftmp);
  while not (eof(ff)) do
    begin
    readln(ff,rida);
    writeln(fftmp,rida);
    end;
  rewrite(ff);
  reset(fftmp);
  i:=0;
  while not (eof(fftmp)) do
    begin
    readln(fftmp,rida);
    inc(i);
    if i=mitm then writeln(ff,setting)
      else writeln(ff,rida);
    end;
  erase(fftmp);
  close(ff);
  end;

function GetFText(fnimi:string; mitm:integer) :string;
    var ff:text;
      rida:string;
      i:integer;
  begin
  assign(ff,fnimi);
  reset(ff);
  for i:=1 to mitm do readln(ff,rida);
  GetFText:=rida;
  end;

procedure Otsing(fnimi:string);

var kask:char;
    vasteid,tyhik,koht,att:longint;
    otnimi,rida,nimi,otaddr,addr,ottekst,otmask,mask:string;
    ff:text;

label lopp;
label valetaht;
  begin
assign(ff,fnimi);
reset(ff);
valetaht:
writeln('Otsi:');
MenyOsa('Nime järgi');
MenyOsa('Addressi järgi');
MenyOsa('Maski järgi');
MenyOsa('Suvalise osa järgi');
MenyOsa('Lahku');
writeln('--------------------------------------------');
VarvOsa('Sisesta täht(n,a,m,k,s,l)','(n,a,m,k,s,l)');
kask:=readkey;
if (kask='n') or (kask='a') or (kask='m') or (kask='k') or (kask='s') or (kask='l') then
  begin
    if kask='l' then goto lopp;
    if kask='n' then
      begin
      vasteid:=0;
      write('Sisesta otsitav nimi: ');
      readln(otnimi);
      writeln('Nimega sobivad addressid: ');

      reset(ff);
      while not (eof(ff)) do
        begin
        readln(ff,rida);
        tyhik:=pos(' ',rida);
        nimi:=copy(rida,1,tyhik-1);
        if nimi=otnimi then
          begin
          VarvOsa(rida,nimi);
          inc(vasteid);
          end;
        end;
      if vasteid>0 then writeln('Leitud ',vasteid,' vastet')
        else writeln('Vasteid ei leitud');
      end;


    if kask='a' then
      begin
      write('Sisesta otsitav address: ');
      readln(otaddr);
      vasteid:=0;
      reset(ff);
      writeln('Addressiga sobivad nimed: ');
      while not (eof(ff)) do
        begin
        readln(ff,rida);
        tyhik:=pos('@',rida);
        addr:=copy(rida,tyhik+1,length(rida));
        if addr=otaddr then
          begin
          VarvOsa(rida,addr);
          inc(vasteid);
          end;
        end;
      if vasteid>0 then writeln('Leitud ',vasteid,' vastet')
        else writeln('Vasteid ei leitud');
      end;

    if kask='s' then
      begin
      vasteid:=0;
      write('Sisesta suvaline tekst: ');
      readln(ottekst);
      reset(ff);
      writeln('Tekstiga sobivad vasted: ');
      while not (eof(ff)) do
        begin
        readln(ff,rida);
        koht:=pos(ottekst,rida);
        if koht<>0 then
          begin
          VarvOsa(rida,ottekst);
          inc(vasteid);
          end;
        end;
      if vasteid<>0 then writeln('Leitud ',vasteid,' vastet')
        else writeln('Vasteid ei leitud');
      end;

    if kask='m' then
      begin
      vasteid:=0;
      write('Sisesta otsitav mask : ');
      readln(otmask);
      reset(ff);
      while not (eof(ff)) do
        begin
        readln(ff,rida);
        tyhik:=pos(' ',rida);
        att:=pos(chr(64),rida);
        mask:=copy(rida,tyhik+4,att-tyhik-4);
        if mask=otmask then
          begin
          inc(vasteid);
          VarvOsa(rida,mask);
          end;
        end;
      if vasteid<>0 then writeln('Leitud ',vasteid,' vastet')
        else writeln('Vasteid ei leitud');
      end;
    end



  else
    begin
    writeln('Sisestasid vale tähe või on sul CapsLock peal');
    goto valetaht;
    end;
  lopp:
  close(ff);
  end;

procedure DelEkraan;
    var i:longint;
  begin
  for i:=1 to 80*25 do write(' ');
  gotoXY(1,1);
  end;

function RidadeArv(fnimi:string) :integer;
    var a:integer;
    ff:text;
    rida:string;

  begin
  assign(ff,fnimi);
  reset(ff);
  a:=0;
  while not (eof(ff)) do
    begin
    readln(ff,rida);
    inc(a);
    end;
  RidadeArv:=a;
  close(ff);
  end;

procedure MenyOsa(lause:string);
  begin
  TextColor(4);
  write(lause[1]);
  TextColor(7);
  writeln(copy(lause,2,length(lause)-1));
  end;

procedure VarvOsa(lause,osa:string);
    var osakoht:byte;
  begin
  TextColor(7);
  osakoht:=pos(osa,lause);
  write(copy(lause,1,osakoht-1));
  TextColor(4);
  write(osa);
  TextColor(7);
  writeln(copy(lause,osakoht+length(osa),length(lause)));
  end;

function DelKorduvad(vfail:string) :string;
    var ridarv,yhik,yhiktmp,abb,nridu:longint;
    ff,ffn:text;
    kirj:boolean;
    kask:char;
    rida,nrida,ufail:string;
    onok:boolean;

label edasi;
begin
clrscr;
writeln('FAILI ':30,vfail,' TÖÖTLEMINE');
write('Sisesta uue faili nimi : '); readln(ufail);
ridarv:=0;
abb:=2;
assign(ff,vfail);
reset(ff);
assign(ffn,ufail);
rewrite(ffn);
while not (eof(ff)) do
  begin
  readln(ff,rida);
  ridarv:=ridarv+1;
  end;
writeln(' --------------------------------------------------');
writeln('[                                                  ]');
writeln(' --------------------------------------------------');
gotoxy(7,7);
writeln('Peatamiseks vajuta ESC');
gotoxy(2,3);
yhik:=round(ridarv/100);
yhiktmp:=yhik;
reset(ff);
readln(ff,rida);
writeln(ffn,rida);
nridu:=1;
while not (eof(ff)) do
  begin
  if keypressed then
    begin
    kask:=readkey;
    if kask=#27 then goto edasi;
    end;
  begin
  readln(ff,rida);
  reset(ffn);
  kirj:=true;
  while not (eof(ffn)) do
    begin
    readln(ffn,nrida);
    if nrida=rida then kirj:=false;
    end;
  if kirj then
    begin
    append(ffn);
    writeln(ffn,rida);
    end;
  inc(nridu);
  if nridu>=(yhik) then
    begin
    gotoxy(abb,4);
    if onok then begin write('-'); onok:=false; inc(abb); end
      else onok:=true;
    yhik:=yhik+yhiktmp;
    gotoxy(25,4);
    write(round((yhik/ridarv)*100),'%');
    end;
  end;
  end;
edasi:
DelKorduvad:=ufail;
gotoxy(2,7);
writeln('Failis ',ufail,' on ',RidadeArv(ufail),' rida');
writeln('Failis ',vfail,' oli ',RidadeArv(vfail),' rida');
writeln('Faili maht vähenes ',round((RidadeArv(vfail)-RidadeArv(ufail))/RidadeArv(vfail)*100),'%');
end;
end.