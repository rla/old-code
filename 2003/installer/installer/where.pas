unit Where;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl, StrUtils, ExtCtrls;

type
  TForm3 = class(TForm)
    DirectoryListBox1: TDirectoryListBox;
    DriveComboBox1: TDriveComboBox;
    Edit1: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Panel1: TPanel;
    Image1: TImage;
    procedure Close(Sender: TObject; var Action: TCloseAction);
    procedure DirChange(Sender: TObject);
    procedure ShowWhereTo(Sender: TObject);
    procedure ChangeDrive(Sender: TObject);
    procedure WhereToOk(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses CopyForm, SetForm, DoInstall, Special;

{$R *.dfm}

procedure TForm3.Close(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TForm3.DirChange(Sender: TObject);
begin
  if rightstr(DirectoryListBox1.Directory, 1)<>'\' then Edit1.Text:=DirectoryListBox1.Directory+'\'+settings.Name
  else Edit1.Text:=DirectoryListBox1.Directory+settings.Name
end;

procedure TForm3.ShowWhereTo(Sender: TObject);
begin
  Edit1.Text:=settings.DefaultDirectory;
  if settings.WhereToDispPic then
  begin
    Panel1.Visible:=true;
    Image1.Picture.LoadFromFile(iset.tempfolder+'whereto.bmp');
  end;
  Button1.Caption:=settings.WhereToNextButton;
end;

procedure TForm3.ChangeDrive(Sender: TObject);
begin
  DirectoryListBox1.Directory:=DriveComboBox1.Drive+':\';
end;

procedure TForm3.WhereToOk(Sender: TObject);
begin
  Form3.Hide;
  ForceDirectories(Edit1.Text);
  iset.folder:=Edit1.Text+'\';
  if settings.UseSettings then
  begin
    Form4.Show;
  end
  else
  begin
    if settings.UseSpecial then
    Special.Form5.Show else
    DoInstall.Form6.Show;
  end;
end;

end.
