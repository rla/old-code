unit CopyForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CabSTComps, StdCtrls, ExtCtrls;

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

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    STCabReader1: TSTCabReader;
    Panel1: TPanel;
    Image1: TImage;
    procedure Start(Sender: TObject);
    procedure Agree(Sender: TObject);
    procedure Disagree(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  settings:setdata;//globaalne

implementation

uses Splash, Where, DoInstall;

{$R *.dfm}

procedure TForm1.Start(Sender: TObject);
  function WindowsTemp : String;
  var
    Buffer : Array[0..Max_path] of char;
  begin
    FillChar(Buffer,Max_Path + 1, 0);
    GetTempPath(Max_path, Buffer);
    Result := String(Buffer);
    if Result[Length(Result)] <> '\' then Result := Result + '\';
  end;
var
  sfile:file of setdata;
  tempdir:string;
begin

  //
  //
  Chdir(ExtractFilePath(Paramstr(0)));
  //
  //
  if not(FileExists('setup.cab')) then
  begin
    ShowMessage('setup.cab not found');
    exit;
  end;

  tempdir:=WindowsTemp+'jcinstaller';//temp kaust
  iset.tempfolder:=tempdir+'\';

  STCabReader1.Create(nil);
  STCabReader1.ExtractFiles('setup.cab', tempdir);
  STCabReader1.Free;

  Image1.Picture.LoadFromFile(iset.tempfolder+'banner.bmp');//näitame bännerit

  AssignFile(sfile, tempdir+'\installer.dat');
  Reset(sfile);
  BlockRead(sfile, settings, 1);//loeme settingud
  CloseFile(sfile);

  Memo1.Color:=settings.CopyNotesBg;
  Memo1.Font.Color:=settings.CopyNotesFontColor;

  Application.Title:=settings.CopyFormTitle;
  Button1.Caption:=settings.AgreeText;
  Button2.Caption:=settings.DisagreeText;

  if settings.DisplaySplash then
  begin
    Splash.Form2.Timer1.Interval:=settings.SplashDelay;
    Splash.Form2.Image1.Picture.LoadFromFile(tempdir+'\splash.bmp');
    Splash.Form2.Height:=Splash.Form2.Image1.Height;
    Splash.Form2.Width:=Splash.Form2.Image1.Width;
    Splash.Form2.Show;
  end;

  Memo1.Lines.LoadFromFile(tempdir+'\copyright.txt');//copyright notes

end;

procedure TForm1.Agree(Sender: TObject);
begin
  Where.Form3.Caption:=settings.WhereToTitle;
  Application.Title:=settings.WhereToTitle;
  Where.Form3.Label1.Caption:=settings.WhereToLabel;
  Where.Form3.Show;
  Form1.Hide;
end;

procedure TForm1.Disagree(Sender: TObject);
begin
  Form1.Close;
end;

end.
