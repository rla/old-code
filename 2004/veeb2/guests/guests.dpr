program guests;

{
CGI külalisteraamat.
Raivo Laanemets 2004
rl@starline.ee
}

{$APPTYPE CONSOLE}

uses
  SysUtils, DateUtils,
  pas_html in 'pas_html.pas';

const
  maxk=4; {kirjete arv ühel lehel}
  maxip=10; {maksimaalne ip'de arv, mida kontrollitakse}
  ipexp=100; {kirjete vaheline aeg samalt hostilt}

type
g_andmed=record {külalisteraamatu sissekannete tüüp}
  nimi: string[20];
  text: string[255];
  aeg: TDateTime;
end;

TIp_Check=record {ip kontroll laamendamise vastu}
  ip: string[16];
  aeg: TDateTime;
end;

var html: Thtml;

function CheckIp: boolean;
var F: file of TIp_Check; ipc: TIp_Check;
begin CheckIp:=false;
  Assign(F, 'g_ips.dat'); Reset(F); if FileSize(F)>0 then Read(F, ipc) else
  begin
    ipc.aeg:=Now;
    ipc.ip:=html.cgi.remote_addr;
    Write(F, ipc); CloseFile(F); exit;
  end;
  if ipc.ip=html.cgi.remote_addr then
    if IncSecond(ipc.aeg, ipexp)>Now then CheckIp:=true
    else
    begin
      ipc.aeg:=Now;
      ipc.ip:=html.cgi.remote_addr;
      Seek(F, 0); Write(F, ipc);
    end;
  CloseFile(F);
end;

procedure Naita; {kirjete näitamine andmefailist}
var koht, err, size, i, lopp: integer; F: file of g_andmed; data: g_andmed;
begin
  writeln('<a href="?page=lisa" target="_self">Lisa sissekanne</a><br>');
  AssignFile(F, 'guests.dat'); Reset(F); size:=FileSize(F);
  if size=0 then begin
    CloseFile(F); exit;
  end;
  Val(html.cgi.Get('koht'), koht, err);
  if (err<>0) or (koht<0) then koht:=size-1;

  if koht>=size then koht:=size-1; Seek(F, koht); lopp:=koht-maxk+1;
  if lopp<0 then lopp:=0;
  for i:=koht downto lopp do begin
    Seek(F, i); Read(F, data);
    writeln('<div class="gb_kirje"><b>' +data.nimi +'</b> :: ' +DateTimeToStr(data.aeg) +'<br>' +data.text +'</div>');
  end;
  if koht<size-maxk then writeln('<a href="?koht=' +IntToStr(koht+maxk) +'" target="_self">&#60;&#60;Eelmised</a>');
  if koht>=maxk then writeln('<a href="?koht=' +IntToStr(koht-maxk) +'" target="_self">Järgmised&#62;&#62;</a>');
  CloseFile(F);
end;

procedure Lisa;
const maxword=15;
var F: file of g_andmed; data: g_andmed; i, w: word;
begin
  if CheckIp then begin
    html.Include('gbook/lame.html'); exit;
  end;
  data.nimi:=html.TagEnc(html.cgi.Post('nimi'));
  data.text:=html.TagEnc(html.cgi.Post('text'));
  if (data.nimi='') or (data.text='') then begin
    html.Include('gbook/viga.html'); exit;
  end; data.aeg:=Now; w:=0;
  for i:=1 to length(data.text) do begin {tühikute sisselükkamine}
    if data.text[i]=' ' then w:=0 else inc(w);
    if w>maxword then begin insert(' ', data.text, i); w:=0; end;
  end;
  AssignFile(F, 'guests.dat'); Reset(F); Seek(F, FileSize(F));
  Write(F, data); CloseFile(F);
  html.Include('gbook/lisatud.html');
end;

begin
html.Create;
html.cgi.SendHeader;
html.Include('gbook/header.html');
if html.page='index' then Naita
else if html.page='lisa' then html.Include('gbook/lisa_frm.html')
else if html.page='lisa_do' then Lisa;

html.Include('gbook/footer.html');
html.Close;
end.
