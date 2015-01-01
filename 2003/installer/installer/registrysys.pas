unit RegistrySys;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Registry, StdCtrls, ExtCtrls;

type
  TForm7 = class(TForm)
    Label1: TLabel;
    Timer1: TTimer;
    procedure Start(Sender: TObject);
    procedure CloseFrm(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation

uses DoInstall, CopyForm;

{$R *.dfm}

procedure TForm7.Start(Sender: TObject);
var
  Reg:TRegistry;
  lfile:TExtFile;
begin
  Form7.Caption:=settings.RegFormTitle;
  Label1.Caption:=settings.RegLabel;

  AssignFile(lfile, iset.folder+'uninstall.log');//avame faili uuesti
  Append(lfile);
  Writeln(lfile, '//registry entries');

  Reg:=TRegistry.Create;
  Reg.RootKey:=HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Uninstall\'+settings.Name, true);//windowsi uninstall settingud
  Writeln(lfile, 'reg HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall\'+settings.Name);
  Reg.WriteString('DisplayName', settings.Name);//nimi mida näidatakse install/uninstall menüüs
  Reg.WriteString('UninstallString', iset.folder+'uninstaller.exe');//uninstalleri nimi ja asukoht
  Reg.CloseKey;
  Reg.Free;

  CloseFile(lfile);//sulgeme uninstall.log faili
end;

procedure TForm7.CloseFrm(Sender: TObject);
begin
  Form7.Close;
  Timer1.Enabled:=false;
end;

end.
