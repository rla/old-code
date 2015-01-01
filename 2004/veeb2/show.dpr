program show;

{$APPTYPE CONSOLE}

{22. juuni 2004 - lisatud automaatmuutujad KEEL, LEHT}

uses
  SysUtils;

type

andmekirje=record
  nimi: string[10]; {muutuja nimi}
  vaartus: string[255]; {muutuja väärtus}
end;

objektityyp=(html, thtml, err, css); {err kasutatakse vea tähistamiseks,
näiteks kui objekti kirjeldust ei asu failis}

{objektide kirjeldused asuvad ühises failis}
objektikirje=record
  nimi: string[10]; {objekti nimi}
  tyyp: objektityyp; {tüübiks võib html või templeit}
end;

urlkirje=record
  nimi: string[8];
  vaartus: string[50];
end;

var
  objektid: file of objektikirje; {objektide fail}
  url: string;
  url_array: array [1..10] of urlkirje;
  page: string[10]; {esitatava lehekülje sisu näitaja}
  lang: string[2]; {esitatava lehekülje keele näitaja}

{GET meetodiga saadetud muutuja väärtuse lugemine}
function UrlVar(muutuja: string): string;
var ok: boolean; i: byte;
begin
  i:=1; ok:=false; UrlVar:='';
  while not(ok) do
  begin
    if url_array[i].nimi=muutuja then
    begin
      UrlVar:=url_array[i].vaartus;
      ok:=true;
    end;
    inc(i);
    if i>10 then ok:=true;
  end;
end;

{objekti leidmine, kahendotsimise algoritm}
function LeiaObjekt(nimi: string): objektityyp;
var l, r, k: word;
  objekt: objektikirje;
begin
  LeiaObjekt:=err;
  l:=0; r:=FileSize(objektid)-1;
  while l<=r do
  begin
    k:=(l+r) div 2;
    Seek(objektid, k);
    Read(objektid, objekt);
    if objekt.nimi=nimi then
    begin
      LeiaObjekt:=objekt.tyyp;
      exit;
    end
    else if objekt.nimi>nimi then r:=k-1
    else l:=k+1;
  end;
end;

{objekti toomine ekraanile, rekursiivne}
procedure Objekt(nimi: string);
var
  F: TextFile;
  tyyp: objektityyp;
  fnimi: string;
  ch: char;
  oldch: char;
  buffer: string;
  mstart: boolean; {märgib muutuja nime algust}
  andmed: file of andmekirje;

  {andmefailist muutuja leidmine}
  function LeiaMuutuja(nimi: string): string;
  var i: word; muutuja: andmekirje;
  begin
    Seek(andmed, 0);
    for i:=0 to FileSize(andmed)-1 do
    begin
      Read(andmed, muutuja);
      if muutuja.nimi=nimi then LeiaMuutuja:=muutuja.vaartus;
    end;
  end;{leia muutuja}

begin
  tyyp:=LeiaObjekt(nimi);
  if tyyp=err then {veakontroll juhuks kui objekti ei leitud}
  begin
    Writeln('Viga!');
    exit;
  end;
  if tyyp=html then {html fail söödetakse kasutajale}
  begin
    fnimi:='./html/' +nimi +'.' +lang +'.html';
    Assign(F, fnimi); Reset(F);
    while not(eof(F)) do begin
      Read(F, ch);
      Write(ch);
    end;
    Close(F); exit;
  end;

  if tyyp=css then {css fail söödetakse kasutajale}
  begin
    fnimi:='./css/' +nimi +'.css';
    Assign(F, fnimi); Reset(F);
    while not(eof(F)) do begin
      Read(F, ch); Write(ch);
    end;
    Close(F); exit;
  end;

  {andmefaili avamine}
  fnimi:='./data/' +nimi +'.' +lang +'.dat';
  Assign(andmed, fnimi); Reset(andmed);
  
  {templeidi töötlemine}
  fnimi:='./thtml/' +nimi +'.tpl';
  Assign(F, fnimi); Reset(F);
  buffer:=''; oldch:=' '; mstart:=false;
  while not(eof(F)) do
  begin
    Read(F, ch);
    if (ch='%') and (oldch='{') then mstart:=true; {muutuja või objekti nime algus}
    if (ch='}') and (oldch='%') and mstart then {muutuja või objekti nime lõpp}
    begin {muutuja või objekti nimi eraldatud}
      buffer:=copy(buffer, 2, length(buffer)-2);
      if buffer[1]=':' then Objekt(copy(buffer, 2, 255))
      else if buffer='@' then Objekt(page)
      else if buffer='KEEL' then write(lang) {automaatmuutujate kontroll}
      else if buffer='LEHT' then write(page)
      else write(LeiaMuutuja(buffer));

      buffer:='';
      mstart:=false;
    end;
    if mstart then buffer:=buffer +ch
    else if (ch<>'}') and (ch<>'{') then write(ch);
    oldch:=ch;
  end;
  Close(F);
  Close(andmed);
end;

{url'i lõhkumine muutujate-väärtuste paarideks}
procedure ParseUrl;
var ch: char; i, j: word; buffer: string;
begin
  buffer:='';
  j:=1;
  for i:=1 to length(url) do
  begin
    ch:=url[i];
    if ch='=' then
    begin
      url_array[j].nimi:=buffer;
      buffer:='';
    end
    else if ch='&' then
    begin
      url_array[j].vaartus:=buffer;
      inc(j);
      buffer:='';
      if j>10 then exit;
    end else buffer:=buffer +ch;
    url_array[j].vaartus:=buffer; {viimase muutuja väärtus}
  end;
end;

begin

{serveri poolt saadetud url lugemine}
url:=GetEnvironmentVariable('QUERY_STRING');

{heederi saatmine}
writeln('Content-type: text/html', chr(10), chr(10));
ParseUrl;

{vajalike muutujate võtmine}
page:=UrlVar('page'); if page='' then page:='index';
lang:=UrlVar('lang'); if lang='' then lang:='ee';


Assign(objektid, 'objektid.dat');
Reset(objektid);

{Peaobjekti sissetoomine}
Objekt('main');

Close(objektid);
end.
