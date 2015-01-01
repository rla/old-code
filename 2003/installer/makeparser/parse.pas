unit Parse;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CabSTComps;

const filen='settings.dat';

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    STCabWriter1: TSTCabWriter;
    procedure Start(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  
type setdata=record//settingud settings.dat
  Name:string[255];

  DisplaySplash:boolean;
  SplashBMP:string[255];
  StrechSplash:boolean;
  MoveBack:boolean;
  SplashDelay:integer;

  ProjectDirectory:string[255];
  CopyFormTitle:string[255];
  AgreeText:string[255];
  DisagreeText:string[255];

  DefaultCopyBanner:boolean;
  CopyBannerBMP:string[255];
  CopyNotesBg:TColor;
  CopyNotesFontColor:TColor;

  WhereToTitle:string[255];
  DefaultDirectory:string[255];
  WhereToLabel:string[255];
  WhereToDispPic:boolean;
  WhereToDefPic:boolean;
  WhereToPicBMP:string[255];
  WhereToNextButton:string[255];

  UseSettings:boolean;
  SettingsTitle:string[255];
  SettingsMemo:string[255];
  NumOfSettings:byte;
  Settings:array [1..25] of string[255];
  DefaultSettings:array [1..25] of boolean;
  SettingsBackButton:string[255];
  SettingsNextButton:string[255];

  UseSpecial:boolean;
  SpecialTitle:string[255];
  Restart:boolean;
  RestartText:string[255];
  Start:boolean;
  StartText:string[255];
  RunCommand:string[255];
  AddShortCut:boolean;
  ShortCutText:string[255];

  CopyTitle:string[255];
  SpecialBackButton:string[255];
  FinishButton:string[255];

  RegFormTitle:string[255];
  RegLabel:string[255];

  FinishText:string[255];
end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
function yesno(test:boolean):string;
begin
  if test then yesno:='yes'
    else yesno:='no';
end;

procedure TForm1.Start(Sender: TObject);
var
  settings:setdata;
  sfile:file of setdata;
  ns:byte;
  lfile:TextFile;
  rida:string;
  lfname:string;
  flist:array [1..512] of string[255];
  farv:integer;
  i:integer;
  folemas:boolean;
  setfile:TextFile;
  npos:integer;
  dir:string;
  progdir:string;
  dfile:TextFile;
begin
  dir:=ParamStr(1);
  progdir:=ExtractFilePath(ParamStr(0));
  ChDir(dir);
  if length(dir)=0 then
  begin
    ShowMessage('Directory error');
    exit;
  end;

  Memo1.Lines.Add('Jc Installer started');
  if FileExists(filen) then Memo1.Lines.Add('Loading settings')
  else
  begin
    Memo1.Lines.Add('File not found');
    exit;
  end;

  Memo1.Lines.Add('');

  farv:=1;
  AssignFile(sfile, 'settings.dat');
  Reset(sfile);
  BlockRead(sfile, settings, 1);
  CloseFile(sfile);//installeri settingud

  AssignFile(setfile, 'settings.lst');//settingute listi fail installerile
  Rewrite(setfile);

  AssignFile(dfile, 'default.lst');//default settingute listi fail
  Reset(dfile);

  STCabWriter1.Create(nil);//tekitame uue .cab protseduuri
  STCabWriter1.CompressionType := cctMsZip;
  STCabWriter1.Open(settings.ProjectDirectory +'\setup.cab');//tekitame setup.cab

  Memo1.Lines.Add('Project name: "'+settings.Name+'"');
  Memo1.Lines.Add('Project directory: "'+settings.ProjectDirectory+'"');
  Memo1.Lines.Add('');//tyhi rida

  if settings.DisplaySplash then
  begin
    STCabWriter1.AddFile(settings.SplashBMP, 'splash.bmp');//lisame splash.bmp
    Memo1.Lines.Add('Splash screen image: "'+settings.SplashBMP+'"');
    Memo1.Lines.Add('Strech splash screen: "'+yesno(settings.StrechSplash)+'"');
    Memo1.Lines.Add('Set splash to background: "'+yesno(settings.MoveBack)+'"');
  end;
  Memo1.Lines.Add('Copyright Form Banner: "'+settings.CopyBannerBMP+'"');
  STCabWriter1.AddFile(settings.CopyBannerBMP, 'banner.bmp');//lisame splash.bmp
  Memo1.Lines.Add('WhereTo Form Picture: "'+settings.WheretoPicBMP+'"');
  STCabWriter1.AddFile(settings.WhereToPicBMP, 'whereto.bmp');//lisame splash.bmp
  Memo1.Lines.Add('Show whereto picture: "'+yesno(settings.WhereToDispPic)+'"');
  Memo1.Lines.Add('');//tyhi rida

  Memo1.Lines.Add('Copyright form title: "'+settings.CopyFormTitle+'"');
  Memo1.Lines.Add('Agree button text: "'+settings.AgreeText+'"');
  Memo1.Lines.Add('Disagree button text: "'+settings.DisagreeText+'"');
  Memo1.Lines.Add('');//tyhi rida

  Memo1.Lines.Add('WhereTo form title: "'+settings.WhereToTitle+'"');
  Memo1.Lines.Add('DefaultDirectory: "'+settings.DefaultDirectory+'"');
  Memo1.Lines.Add('WhereToLabel: "'+settings.WhereToLabel+'"');
  Memo1.Lines.Add('WhereTo next button caption: "'+settings.WhereToNextButton+'"');
  Memo1.Lines.Add('');//tyhi rida


  Memo1.Lines.Add('Use settings: "'+yesno(settings.UseSettings)+'"');
  Memo1.Lines.Add('Settings form title: "'+settings.SettingsTitle+'"');
  Memo1.Lines.Add('Settings memo: "'+settings.SettingsMemo+'"');
  Memo1.Lines.Add('Settings back button text: "'+settings.SettingsBackButton+'"');
  Memo1.Lines.Add('Settings next button text: "'+settings.SettingsNextButton+'"');
  Memo1.Lines.Add('Number of settings: "'+IntToStr(settings.NumOfSettings)+'"');
  Memo1.Lines.Add('');

  Memo1.Lines.Add('Settings {');
  for ns:=1 to settings.NumOfSettings do
  begin
    Memo1.Lines.Add(' "' +settings.Settings[ns]+'"');
    AssignFile(lfile, 'list'+IntToStr(ns-1)+'.lst');
    Reset(lfile);
    WriteLn(setfile, 'list'+IntToStr(ns-1)+' {');
    while not(eof(lfile)) do
    begin
      Readln(lfile, rida);
      npos:=pos(' -> ', rida);
      lfname:=copy(rida, 1, npos-1);
      WriteLn(setfile, ExtractFileName(lfname)+'->'+copy(rida, npos+4, length(rida)-npos-3));//eraldi settingu faili nimi
      folemas:=false;
      for i:=1 to farv do
      begin
        if flist[i]=lfname then folemas:=true;
      end;
      if not(folemas) then
      begin
        flist[farv]:=lfname;
        inc(farv);
      end;
      Memo1.Lines.Add(' -'+rida);
    end;
    WriteLn(setfile, '}');
    CloseFile(lfile);
    Memo1.Lines.Add('');
  end;
  Memo1.Lines.Add('}');
  Memo1.Lines.Add('');

  Memo1.Lines.Add('Default files list:');
  AssignFile(dfile, 'default.lst');
  Reset(dfile);
  WriteLn(setfile, 'default {');
  while not(eof(dfile)) do
  begin
    ReadLn(dfile, rida);
    npos:=pos(' -> ', rida);
    lfname:=copy(rida, 1, npos-1);
    WriteLn(setfile, ExtractFileName(lfname)+'->'+copy(rida, npos+4, length(rida)-npos-3));
    Memo1.Lines.Add(' -'+rida);
    folemas:=false;
    for i:=1 to farv do
    begin
      if flist[i]=lfname then folemas:=true;
    end;
    if not(folemas) then
    begin
      flist[farv]:=lfname;
      inc(farv);
    end;
  end;
  WriteLn(setfile, 'uninstaller.exe->%path\uninstaller.exe');
  WriteLn(setfile, '}');
  CloseFile(dfile);
  Memo1.Lines.Add('');

  if settings.UseSpecial then
  begin
    Memo1.Lines.Add('Use special: "'+yesno(settings.UseSpecial)+'"');
    Memo1.Lines.Add('Special form title: "'+settings.SpecialTitle+'"');
    Memo1.Lines.Add('Special form back button text: "'+settings.SpecialBackButton+'"');
    Memo1.Lines.Add('Special form finish button: "'+settings.FinishButton+'"');
    if settings.Restart then Memo1.Lines.Add('Restart Text: "'+settings.RestartText+'"');
    if settings.Start then
    begin
      Memo1.Lines.Add('Start text: "'+settings.StartText+'"');
      Memo1.Lines.Add('Run command: "'+settings.RunCommand+'"');
    end;
    if settings.AddShortCut then Memo1.Lines.Add('Shortcut text: "'+settings.ShortCutText+'"');
  end;
  Memo1.Lines.Add('');

  Memo1.Lines.Add('Files coping form title: "'+settings.CopyTitle+'"');
  Memo1.Lines.Add('Register form title: "'+settings.RegFormTitle+'"');
  Memo1.Lines.Add('Register form label: "'+settings.RegLabel+'"');
  Memo1.Lines.Add('');

  Memo1.Lines.Add('Adding files to setup.cab');
  for i:=1 to farv-1 do
  begin
    Memo1.Lines.Add(flist[i]);
    STCabWriter1.AddFile(flist[i], ExtractFileName(flist[i]));//lisame faili
  end;

  STCabWriter1.AddFile(progdir+'\uninstaller.exe', 'uninstaller.exe');
  STCabWriter1.AddFile('copyright.txt', 'copyright.txt');//lisame faili copyright.txt

  CloseFile(setfile);//settingute listi faili sulgemine

  AssignFile(sfile, 'installer.dat');
  Rewrite(sfile);

  //muudame ära piltide nimed
  settings.SplashBMP:='splash.bmp';
  settings.CopyBannerBMP:='banner.bmp';
  settings.WhereToPicBMP:='whereto.bmp';
  //-------------------------

  Blockwrite(sfile, settings, 1);//kirjutame settingud uude faili
  CloseFile(sfile);//installeri settingute faili sulgemine

  STCabWriter1.AddFile('settings.lst', 'settings.lst');//lisame faili settings.lst
  STCabWriter1.AddFile('installer.dat', 'installer.dat');//lisame faili installer.dat

  STCabWriter1.Close;
  STCabWriter1.Free;

  Memo1.Lines.Add('');
  Memo1.Lines.Add('Finished - setup.cab succesfully created!');
end;

end.
