unit Algus;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtDlgs, ShellCtrls, CheckLst, Menus, ShellAPI,
  ExtCtrls;

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
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    Edit2: TEdit;
    Label2: TLabel;
    TabSheet3: TTabSheet;
    Label1: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    Edit4: TEdit;
    Label5: TLabel;
    CheckBox1: TCheckBox;
    Edit5: TEdit;
    Label6: TLabel;
    Button1: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    GroupBox3: TGroupBox;
    ShellTreeView1: TShellTreeView;
    Edit6: TEdit;
    Label7: TLabel;
    Edit7: TEdit;
    Button2: TButton;
    Label8: TLabel;
    TabSheet4: TTabSheet;
    Label9: TLabel;
    Edit8: TEdit;
    Label10: TLabel;
    Edit9: TEdit;
    CheckListBox1: TCheckListBox;
    Label11: TLabel;
    Edit10: TEdit;
    CheckBox2: TCheckBox;
    Button3: TButton;
    PopupMenu1: TPopupMenu;
    Kustuta1: TMenuItem;
    Edit11: TEdit;
    Label12: TLabel;
    Edit12: TEdit;
    Label13: TLabel;
    Memo2: TMemo;
    Label14: TLabel;
    TabSheet5: TTabSheet;
    CheckBox3: TCheckBox;
    Edit13: TEdit;
    Label15: TLabel;
    CheckBox4: TCheckBox;
    Label16: TLabel;
    Edit14: TEdit;
    Edit15: TEdit;
    Label17: TLabel;
    Label18: TLabel;
    CheckBox5: TCheckBox;
    Edit16: TEdit;
    Label19: TLabel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    PopupMenu2: TPopupMenu;
    FileList1: TMenuItem;
    CheckBox6: TCheckBox;
    Edit17: TEdit;
    Label20: TLabel;
    Button4: TButton;
    Button5: TButton;
    ColorBox1: TColorBox;
    Label21: TLabel;
    ColorBox2: TColorBox;
    Label22: TLabel;
    Image1: TImage;
    Label23: TLabel;
    Edit18: TEdit;
    Button6: TButton;
    CheckBox7: TCheckBox;
    OpenPictureDialog2: TOpenPictureDialog;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    Label24: TLabel;
    Edit19: TEdit;
    Label25: TLabel;
    Edit20: TEdit;
    Edit21: TEdit;
    TabSheet6: TTabSheet;
    Label26: TLabel;
    CheckBox8: TCheckBox;
    Image2: TImage;
    Edit22: TEdit;
    CheckBox11: TCheckBox;
    Button7: TButton;
    OpenPictureDialog3: TOpenPictureDialog;
    Label27: TLabel;
    Edit23: TEdit;
    Label28: TLabel;
    Edit24: TEdit;
    Edit25: TEdit;
    Label29: TLabel;
    Label30: TLabel;
    Edit26: TEdit;
    Label31: TLabel;
    Edit27: TEdit;
    Label32: TLabel;
    ScrollBar1: TScrollBar;
    Label33: TLabel;
    Label34: TLabel;
    Edit28: TEdit;
    Label35: TLabel;
    Delete1: TMenuItem;
    ListBox1: TListBox;
    Label36: TLabel;
    Button8: TButton;
    Label37: TLabel;
    Button9: TButton;
    OpenDialog1: TOpenDialog;
    procedure SplashClick(Sender: TObject);
    procedure OtsiPilt(Sender: TObject);
    procedure ChangeProDir(Sender: TObject; Node: TTreeNode);
    procedure CreateNewDir(Sender: TObject);
    procedure LisaSetting(Sender: TObject);
    procedure RemSetting(Sender: TObject);
    procedure TeeFileList(Sender: TObject);
    procedure CloseForm(Sender: TObject);
    procedure MakeInstall(Sender: TObject);
    procedure Start(Sender: TObject);
    procedure ChangeCopyColor(Sender: TObject);
    procedure ChengeFontColor(Sender: TObject);
    procedure OpenBanner(Sender: TObject);
    procedure UseDefBanner(Sender: TObject);
    procedure WhereToDisp(Sender: TObject);
    procedure BrowseWherePic(Sender: TObject);
    procedure UseDefWherePic(Sender: TObject);
    procedure ChangeTime(Sender: TObject);
    procedure KustutaList(Sender: TObject);
    procedure AddDefault(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  progdir: string;
  defsize: longint;

implementation

uses FilesList, DefFList;

{$R *.dfm}

procedure TForm1.SplashClick(Sender: TObject);
begin
  Edit5.Enabled:=CheckBox1.Checked;
end;

procedure TForm1.OtsiPilt(Sender: TObject);
begin
  if not(CheckBox1.Checked) then exit;
  OpenPictureDialog1.Filter:='*.bmp';
  if OpenPictureDialog1.Execute then
  begin
    Edit5.Text:=OpenPictureDialog1.FileName;
  end;
end;

procedure TForm1.ChangeProDir(Sender: TObject; Node: TTreeNode);
begin
  Edit6.Text:=ShellTreeView1.Path;
end;

procedure TForm1.CreateNewDir(Sender: TObject);
var
  newpath:string;
  shellpath:string;
begin
  shellpath:=ShellTreeView1.Path;
  if copy(shellpath, length(shellpath), 1)='\' then newpath:=shellpath+Edit7.Text
  else newpath:=shellpath+'\'+Edit7.Text;
  ForceDirectories(newpath);
  Edit6.Text:=newpath;
  ShellTreeView1.Update;
end;


procedure TForm1.LisaSetting(Sender: TObject);
begin
  CheckListBox1.Items.Add(Edit10.Text);
end;

procedure TForm1.RemSetting(Sender: TObject);
begin
  CheckListBox1.Items.Delete(CheckListBox1.ItemIndex);
end;

procedure TForm1.TeeFileList(Sender: TObject);
begin
  FilesList.Form2.Caption:='Files List ' +CheckListBox1.Items.Strings[CheckListBox1.ItemIndex];
  FilesList.Form2.ShowModal;
end;

procedure TForm1.CloseForm(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.MakeInstall(Sender: TObject);
var
  settings:setdata;
  sfile:file of setdata;
  i:integer;
  dirpath:string;
begin

  settings.Name:=Edit4.Text;

  settings.DisplaySplash:=CheckBox1.Checked;
  settings.SplashBMP:=Edit5.Text;
  settings.StrechSplash:=CheckBox10.Checked;
  settings.MoveBack:=CheckBox9.Checked;
  settings.SplashDelay:=ScrollBar1.Position;

  settings.ProjectDirectory:=Edit6.Text;
  settings.CopyFormTitle:=Edit3.Text;
  settings.AgreeText:=Edit2.Text;
  settings.DisagreeText:=Edit1.Text;
  settings.DefaultCopyBanner:=CheckBox7.Checked;
  if settings.DefaultCopyBanner then settings.CopyBannerBMP:=progdir+'\'+Edit18.Text
    else settings.CopyBannerBMP:=Edit18.Text;//bänneri bitmap fail
  settings.CopyNotesBg:=ColorBox1.Selected;
  settings.CopyNotesFontColor:=ColorBox2.Selected;

  settings.WhereToTitle:=Edit12.Text;
  settings.DefaultDirectory:=Edit8.Text;
  settings.WhereToLabel:=Edit9.Text;
  settings.WhereToDispPic:=CheckBox8.Checked;
  settings.WhereToDefPic:=CheckBox11.Checked;
  if settings.WhereToDefPic then settings.WhereToPicBMP:=progdir+'\'+Edit22.Text
    else settings.WhereToPicBMP:=Edit22.Text;//whereto pildi fail
  settings.WhereToNextButton:=Edit19.Text;


  settings.UseSettings:=CheckBox2.Checked;
  settings.SettingsTitle:=Edit11.Text;
  settings.SettingsMemo:=Memo2.Text;
  settings.NumOfSettings:=CheckListBox1.Count;
  for i:=1 to CheckListBox1.Count do settings.Settings[i]:=CheckListBox1.Items.Strings[i-1];
  for i:=1 to CheckListBox1.Count do settings.DefaultSettings[i]:=CheckListBox1.Checked[i-1];
  settings.SettingsBackButton:=Edit20.Text;
  settings.SettingsNextButton:=Edit21.Text;


  settings.UseSpecial:=CheckBox6.Checked;
  settings.SpecialTitle:=Edit17.Text;
  settings.Restart:=CheckBox3.Checked;
  settings.RestartText:=Edit13.Text;
  settings.Start:=CheckBox4.Checked;
  settings.StartText:=Edit14.Text;
  settings.RunCommand:=Edit15.Text;
  settings.AddShortCut:=CheckBox5.Checked;
  settings.ShortCutText:=Edit16.Text;

  settings.CopyTitle:=Edit27.Text;
  settings.SpecialBackButton:=Edit23.Text;
  settings.FinishButton:=Edit24.Text;

  settings.RegFormTitle:=Edit25.Text;
  settings.RegLabel:=Edit26.Text;

  settings.FinishText:=Edit28.Text;

  dirpath:=trim(Edit6.Text);
  if copy(dirpath,length(dirpath),1)<>'\' then dirpath:=dirpath+'\';
  AssignFile(sfile, dirpath +'settings.dat');
  Rewrite(sfile);
  BlockWrite(sfile, settings, 1);
  CloseFile(sfile);

  Memo1.Lines.SaveToFile(dirpath +'copyright.txt');
  ListBox1.Items.SaveToFile(dirpath +'default.lst');//salvestame default listi faili
  
  ShowMessage('Installer ok');
  ShellExecute(Form1.Handle, nil, Pchar(progdir +'\Parser.exe'), PChar(dirpath), nil, SW_SHOW)
end;

procedure TForm1.Start(Sender: TObject);
begin
  GetDir(0, progdir);
end;

procedure TForm1.ChangeCopyColor(Sender: TObject);
begin
  Memo1.Color:=ColorBox1.Selected;
end;

procedure TForm1.ChengeFontColor(Sender: TObject);
begin
  Memo1.Font.Color:=ColorBox2.Selected;
end;

procedure TForm1.OpenBanner(Sender: TObject);
begin
  if OpenPictureDialog2.Execute then
  begin
    Edit18.Text:=OpenPictureDialog2.FileName;
    CheckBox7.Checked:=false;
    Edit18.Enabled:=true;
    Image1.Picture.LoadFromFile(OpenPictureDialog2.FileName);
  end;
end;

procedure TForm1.UseDefBanner(Sender: TObject);
begin
  if CheckBox7.Checked then
  begin
    Edit18.Enabled:=false;
    Edit18.Text:='banner.bmp';
    Image1.Picture.LoadFromFile('banner.bmp');
  end;
end;

procedure TForm1.WhereToDisp(Sender: TObject);
begin
  if CheckBox8.Checked then Image2.Visible:=true
  else Image2.Visible:=false;
end;

procedure TForm1.BrowseWherePic(Sender: TObject);
begin
  if OpenPictureDialog3.Execute then
  begin
    CheckBox11.Checked:=false;
    Edit22.Enabled:=true;
    Edit22.Text:=OpenPictureDialog3.FileName;
    Image2.Picture.LoadFromFile(OpenPictureDialog3.FileName);
  end;
end;

procedure TForm1.UseDefWherePic(Sender: TObject);
begin
  if CheckBox1.Enabled then
  begin
    Edit22.Enabled:=false;
    Edit22.Text:='whereto.bmp';
    Image2.Picture.LoadFromFile('whereto.bmp');
  end;
end;

procedure TForm1.ChangeTime(Sender: TObject);
begin
  Label34.Caption:=IntToStr(ScrollBar1.Position)+' ms';
end;

procedure TForm1.KustutaList(Sender: TObject);
begin
  CheckListBox1.DeleteSelected;
end;

procedure TForm1.AddDefault(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    if ListBox1.Count<1 then defsize:=0;
    DefFList.Form4.Edit1.Text:='%path\'+ExtractFileName(OpenDialog1.FileName);
    DefFList.Form4.ShowModal;
  end;
end;

end.
