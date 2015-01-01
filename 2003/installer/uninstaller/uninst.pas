unit UnInst;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StrUtils, Registry, ExtCtrls;

const fnimi='uninstall.log';

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Timer1: TTimer;
    procedure Start(Sender: TObject);
    procedure CloseFrm(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Start(Sender: TObject);
var
  lfile:TextFile;
  rida:string;
  dfnimi:string;
  Reg:TRegistry;
  rootkey:string;
  key:string;
begin
  if not(FileExists(fnimi)) then
  begin
    ShowMessage('file uninstall.log not found');
    exit;
  end;

  AssignFile(lfile, fnimi);//fail uninstall log
  Reset(lfile, fnimi);

  Reg:=TRegistry.Create;//avame registri
  while not(eof(lfile)) do
  begin
    Readln(lfile, rida);
    if copy(rida, 1, 4)='file' then
    begin
      dfnimi:=copy(rida, 6, length(rida)-4);
      if not(FileExists(dfnimi)) then Memo1.Lines.Add('File ' +dfnimi +' does not exist')
      else
      begin
        DeleteFile(dfnimi);
        Memo1.Lines.Add('File ' +dfnimi +' deleted')
      end;
    end;
    if copy(rida, 1, 3)='reg' then
    begin
      dfnimi:=copy(rida, 5, length(rida)-3);
      rootkey:=leftstr(dfnimi, pos('\', dfnimi)-1);//registri juur
      key:=rightstr(dfnimi, length(dfnimi)-pos('\', dfnimi)+1);
      if rootkey='HKEY_LOCAL_MACHINE' then
      begin
        Reg.RootKey:=HKEY_LOCAL_MACHINE;
        if Reg.DeleteKey(key) then Memo1.Lines.Add('Registry entry '+dfnimi+' deleted');//kustutame key
      end;
    end;
  end;
  CloseFile(lfile);
  Reg.Free;//vabastame registri
end;

procedure TForm1.CloseFrm(Sender: TObject);
begin
  Timer1.Enabled:=false;
  ShowMessage('Uninstall Completed');
  Form1.Close;
end;

end.
