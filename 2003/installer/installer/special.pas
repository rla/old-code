unit Special;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm5 = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    procedure CloseFrm(Sender: TObject; var Action: TCloseAction);
    procedure GetSettings(Sender: TObject);
    procedure Back(Sender: TObject);
    procedure DoInstalling(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

uses CopyForm, SetForm, DoInstall, Where;

{$R *.dfm}

procedure TForm5.CloseFrm(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TForm5.GetSettings(Sender: TObject);
begin
  Application.Title:=settings.SpecialTitle;
  Form5.Caption:=settings.SpecialTitle;
  Button1.Caption:=settings.SpecialBackButton;
  Button2.Caption:=settings.FinishButton;
  if settings.Restart then
  begin
    CheckBox1.Visible:=true;
    CheckBox1.Caption:=settings.RestartText;
  end;
  if settings.Start then
  begin
    CheckBox2.Visible:=true;
    CheckBox2.Caption:=settings.StartText;
  end;
  if settings.AddShortCut then
  begin
    CheckBox3.Visible:=true;
    CheckBox3.Caption:=settings.ShortCutText;
  end;
end;

procedure TForm5.Back(Sender: TObject);
begin
  Form5.Hide;
  if settings.UseSettings then SetForm.Form4.Show
  else Where.Form3.Show;
end;

procedure TForm5.DoInstalling(Sender: TObject);
begin
  iset.restart:=CheckBox1.Checked and settings.Restart;
  iset.start:=CheckBox2.Checked and settings.Start;
  iset.shortcut:=CheckBox3.Checked and settings.AddShortCut;
  Form5.Hide;
  DoInstall.Form6.Show;
end;

end.
