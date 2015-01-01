unit DoInstall;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ShlObj, ActiveX, ComObj;

type
  TForm6 = class(TForm)
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    procedure Start(Sender: TObject);
    procedure CloseFrm(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type isetdata=record
  folder:string;
  tempfolder:string;
  settings:array [0..24] of boolean;
  restart:boolean;
  start:boolean;
  shortcut:boolean;
end;

var
  Form6: TForm6;
  iset:isetdata;

implementation

uses CopyForm, RegistrySys;

{$R *.dfm}

procedure TForm6.Start(Sender: TObject);
  function SaaKaust(dir:string):string;
  var
    i:integer;
  begin
    i:=length(dir);
    while (dir[i]<>'\') and (i>1) do dec(i);//saame '\' asukoha
    SaaKaust:=copy(dir, 1, i-1);
  end;
var
  flist:array [1..512] of string;
  tfile:TextFile;
  rida:string;
  farv:integer;
  i:integer;
  algf:string;
  loppf:string;

  IObject:IUnknown;
  ISLink:IShellLink;
  IPFile:IPersistFile;
  PIDL:PItemIDList;
  InFolder:array[0..MAX_PATH] of Char;
  TargetName:String;
  LinkName:WideString;

  lfile:TextFile;
  idir:string;
begin
  Form6.Caption:=settings.CopyTitle;
  Label1.Caption:=settings.CopyTitle;

  AssignFile(lfile, iset.folder+'uninstall.log');//uninstall.log fail uninstalli tarvis
  Rewrite(lfile);
  Writeln(lfile, '//Install log for uninstalling');

  farv:=1;
  Label1.Caption:='Collecting information';
  AssignFile(tfile, iset.tempfolder+'settings.lst');
  Reset(tfile);
  while not(eof(tfile)) do
  begin
    Readln(tfile, rida);
    if (pos('list', rida)>0) and (iset.settings[StrToInt(rida[5])]) then
    begin
      repeat
      Readln(tfile, rida);
      if rida<>'}' then
      begin
        Label1.Caption:=rida;
        flist[farv]:=rida;
        inc(farv);
      end;
      until pos('}', rida)>0;
    end;
    if pos('default', rida)>0 then
    begin
      repeat
      Readln(tfile, rida);
      if rida<>'}' then
      begin
        Label1.Caption:=rida;
        flist[farv]:=rida;
        inc(farv);
      end;
      until pos('}', rida)>0;
    end;
  end;
  CloseFile(tfile);//kopeeritavate failide nimekiri olemas
  Progressbar1.Position:=10;
  Label1.Caption:='Coping files';
  
  for i:=1 to farv-1 do//failide kopeerimine
  begin
    rida:=flist[i];
    algf:=copy(rida, 1, pos('->', rida)-1);
    loppf:=copy(rida, pos('->', rida)+8, length(rida)-pos('->', rida)+2);
    idir:=SaaKaust(iset.folder +loppf);
    if not(DirectoryExists(idir)) then ForceDirectories(idir);
    if CopyFile(PChar(iset.tempfolder+algf), PChar(iset.folder+loppf), false) then Writeln(lfile, 'file '+iset.folder+loppf);//faili nimi uninstalli tarbeks
  end;
  Progressbar1.Position:=75;

  //---------------Lingi tegemine-------------------
  if iset.shortcut then
  begin
    TargetName:=iset.folder+copy(settings.RunCommand, 7, length(settings.RunCommand)-6);
    IObject := CreateComObject(CLSID_ShellLink);
    ISLink  := IObject as IShellLink;
    IPFile  := IObject as IPersistFile;
    with ISLink do begin
      SetPath(pChar(TargetName));
      SetWorkingDirectory(pChar(ExtractFilePath(TargetName)));
    end;
    SHGetSpecialFolderLocation(0, CSIDL_DESKTOPDIRECTORY, PIDL);
    SHGetPathFromIDList(PIDL, InFolder);

    LinkName:=String(InFolder)+ '\'+settings.Name+'.lnk';
    Writeln(lfile, 'file '+LinkName);//lingi nimi uninstalli jaoks
    IPFile.Save(PWChar(LinkName), false);
  end;
  //-----lingi tegemise lõpp-----------

  CloseFile(lfile);//sulgeme uninstall.log faili

  RegistrySys.Form7.Show;

  Progressbar1.Position:=100;

  ShowMessage(settings.FinishText);
  Application.Terminate;
end;

procedure TForm6.CloseFrm(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

end.
