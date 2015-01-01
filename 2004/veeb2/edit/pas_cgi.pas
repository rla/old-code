unit pas_cgi;

{
pas_cgi
CGI kasutamise abifunktsioonid.
(c) Raivo Laanemets 2004

POST meetod nõuab suurte andmemahtude tõttu suuri stringe.

27.06.04 -
  küpsised toimivad kõik sessiooniküpsistena
  parandatud andmete lugemisel tekkivad vead.
}

interface
uses SysUtils;

type
qptr=^qrec;
dptr=^drec;

qrec=record
  nimi: string;
  vaartus: string;
  next: qptr;
end;

drec=record
  nimi: string;
  vaartus: string;
  next: dptr;
end;

cptr=^cookierec;
cookierec=record {küpsisekirje}
  nimi: string;
  vaartus: string;
  next: cptr;
end;

Tcgi=object {objekt cgi kasutamiseks}
  public
  content_type: string; {content-tüüp, vaikimisi text/html}

  {CGI muutujad}
  remote_addr: string; {kasutaja (brauseri) ip}
  path_info: string; {cgi programminimele lisatud kaustapuu tee}
  http_cookie: string; {kasutaja saadetud küpsis}

  procedure SendHeader; {päise saatmine}
  procedure Create; {algmuutujate seadmine, andmete lugemine}
  procedure Close; {mälu vabastamine}
  function Get(muutuja: string): string; {get meetodi muutuja väärtuse saamine}
  function Post(muutuja: string): string; {post meetodiga muutuja väärtuse saamine}
  function Cookie(muutuja: string): string; {küpsise muutuja lugemine}
  procedure SendCookie(cook_dat: string; expires: longint); {küpsise saatmine, cook_dat formaadist loe lähemalt.
  SendCookie peab toimuma enne SendHeader'it}

  private
  query: string;
  query_start: qptr; {GET saadetud muutujate listi algus}
  data_start: dptr; {POST saadetud muutujate listi algus}
  cookie_start: cptr; {küpsise muutujate listi algus}
  procedure ParseQuery; {GET stringi lõhkumine muutujateks}
  procedure ParseData; {POST muutujaga saadud andmete töötlus}
  procedure ParseCookie; {Küpsisega saadetud andmete töötlus}
  function Hex2Int(inp: char): byte; {teisendamine 16-süsteemist 10-ndsüsteemi}
end;

implementation

function Tcgi.Hex2Int(inp: char): byte;
Begin
   Hex2Int:=0;
   if inp in ['A'..'F'] then Hex2Int:=Ord(inp)-$37
   else if inp in ['0'..'9'] then Hex2Int:=Ord(inp)-$30
   else if inp in ['a'..'f'] then Hex2Int:=Ord(inp)-$57;
end;

procedure Tcgi.SendCookie(cook_dat: string; expires: longint);
begin
  write('Set-Cookie: ' +cook_dat +chr(10));
end;

procedure Tcgi.SendHeader;
begin
  writeln('Content-type: ', content_type, chr(10), chr(10));
end;

procedure Tcgi.Create;
begin
  content_type:='text/html'; query_start:=nil; data_start:=nil; cookie_start:=nil;
  query:=GetEnvironmentVariable('QUERY_STRING'); ParseQuery;
  if GetEnvironmentVariable('REQUEST_METHOD')='POST' then ParseData;
  {teiste cgi muutujate lugemine}
  remote_addr:=GetEnvironmentVariable('REMOTE_ADDR');
  path_info:=GetEnvironmentVariable('PATH_INFO');
  http_cookie:=GetEnvironmentVariable('HTTP_COOKIE');
  if length(http_cookie)>0 then ParseCookie;
end;

procedure Tcgi.ParseCookie;
var ch: char; nimi, vaartus, buffer: string; i: word; varr: boolean; {varr-näitab '=' leidmist}
  procedure Lisa(nimi, vaartus: string); {väärtuse-muutuja paari lisamine}
  var uus: cptr;
  begin
    New(uus); uus^.nimi:=trim(nimi); uus^.vaartus:=trim(vaartus);
    uus^.next:=cookie_start; cookie_start:=uus;
  end;
begin
  buffer:=''; varr:=false;
  for i:=1 to length(http_cookie) do begin
    ch:=http_cookie[i];
    if ch='=' then begin
      nimi:=buffer; buffer:=''; varr:=true;
    end
    else if ch=';' then begin
      Lisa(nimi, buffer); varr:=false; buffer:='';
    end else buffer:=buffer+ch;
  end;
  if varr then Lisa(nimi, buffer); {viimane muutuja küpsises}
end;

procedure Tcgi.ParseData;
var ch, n1, n2 : char; i: longint; nimi, vaartus, buffer: string;
  procedure Lisa(nimi, vaartus: string); {väärtuse-muutuja paari lisamine}
  var uus: dptr;
  begin
    New(uus); uus^.nimi:=nimi; uus^.vaartus:=vaartus;
    uus^.next:=data_start; data_start:=uus;
  end;
begin
  buffer:=''; i:=0;
  while i<StrToInt(GetEnvironmentVariable('CONTENT_LENGTH')) do begin
    inc(i); Read(ch);
    if ch='%' then begin
      Read(n1); Read(n2); i:=i+2; {kodeeritud märkide lahtiseletamine}
      buffer:=buffer +(Chr(Hex2Int(n1)*16 +Hex2Int(n2)));
    end
    else if ch='+' then buffer:=buffer +' '
    else if ch='=' then begin {muutuja-vaartuse eraldaja}
      nimi:=buffer; buffer:='';
    end
    else if ch='&' then begin {vaartuse-muutuja eraldaja}
      Lisa(nimi, buffer); buffer:='';
    end
    else buffer:=buffer +ch;
  end;
  Lisa(nimi, buffer); {viimase muutuja väärtus}
end;

procedure Tcgi.ParseQuery;
var ch: char; i: word; nimi, buffer: string;
  procedure Lisa(nimi, vaartus: string); {väärtuse-muutuja paari lisamine}
  var uus: qptr;
  begin
    New(uus); uus^.nimi:=nimi; uus^.vaartus:=vaartus;
    uus^.next:=query_start; query_start:=uus;
  end;
begin
  if query='' then exit; buffer:=''; 
  for i:=1 to length(query) do begin
    ch:=query[i];
    if ch='=' then begin
      nimi:=buffer; buffer:='';
    end
    else if ch='&' then begin
      Lisa(nimi, buffer); buffer:='';
    end else buffer:=buffer +ch;
  end;
  Lisa(nimi, buffer); {viimase muutuja väärtus}
end;

function Tcgi.Post(muutuja: string): string;
var cur: dptr; ok: boolean;
begin
  ok:=false; cur:=data_start; Post:='';
  while not(ok) do begin
    if cur=nil then exit;
    if muutuja=cur^.nimi then begin
      ok:=true; Post:=cur^.vaartus;
    end;
    cur:=cur^.next;
  end;
end;

function Tcgi.Cookie(muutuja: string): string;
var cur: cptr; ok: boolean;
begin
  ok:=false; cur:=cookie_start; Cookie:='';
  while not(ok) do begin
    if cur=nil then exit;
    if muutuja=cur^.nimi then begin
      ok:=true; Cookie:=cur^.vaartus;
    end;
    cur:=cur^.next;
  end;
end;

function Tcgi.Get(muutuja: string): string;
var cur: qptr; ok: boolean;
begin
  ok:=false; cur:=query_start; Get:='';
  while not(ok) do begin
    if cur=nil then exit;
    if muutuja=cur^.nimi then begin
      ok:=true; Get:=cur^.vaartus;
    end;
    cur:=cur^.next;
  end;
end;

procedure Tcgi.Close;
var cd, cd_tmp: dptr; cq, cq_tmp: qptr; c, c_tmp: cptr;
begin
  cd:=data_start; cq:=query_start; c:=cookie_start;
  while cd<>nil do begin {post andmete tühjendus}
    cd_tmp:=cd; cd:=cd^.next; Dispose(cd_tmp);
  end;
  while cq<>nil do begin {get andmete tühjendus}
    cq_tmp:=cq; cq:=cq^.next; Dispose(cq_tmp);
  end;
  while c<>nil do begin {küpsise andmete tühjendus}
    c_tmp:=c; c:=c^.next; Dispose(c_tmp);
  end;
end;

end.
