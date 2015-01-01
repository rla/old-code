unit SetForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst;

type
  TForm4 = class(TForm)
    CheckListBox1: TCheckListBox;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    procedure CloseFrm(Sender: TObject; var Action: TCloseAction);
    procedure GoBack(Sender: TObject);
    procedure SettingsOk(Sender: TObject);
    procedure Start(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

uses CopyForm, Where, Special, DoInstall;

{$R *.dfm}

procedure TForm4.CloseFrm(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TForm4.GoBack(Sender: TObject);
begin
  Memo1.Clear;
  CheckListBox1.Clear;
  Form4.Hide;
  Where.Form3.Show;
end;

procedure TForm4.SettingsOk(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to settings.NumOfSettings-1 do iset.settings[i]:=CheckListBox1.Checked[i];
  if settings.UseSpecial then
  begin
    Special.Form5.Show;
    Form4.Hide;
  end;
end;

procedure TForm4.Start(Sender: TObject);
var
 i:integer;
begin
  Form4.Caption:=settings.SettingsTitle;
  Application.Title:=settings.SettingsTitle;
  Form4.Memo1.Text:=settings.SettingsMemo;
  for i:=1 to settings.NumOfSettings do
  begin
    CheckListBox1.Items.Add(settings.Settings[i]);
    CheckListBox1.ItemEnabled[i-1]:=not(settings.DefaultSettings[i]);
    CheckListBox1.Checked[i-1]:=settings.DefaultSettings[i];
  end;
  Button1.Caption:=settings.SettingsBackButton;
  Button2.Caption:=settings.SettingsNextButton;
end;

end.
