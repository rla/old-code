unit HTMLForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, FileCtrl;

type
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    StaticText1: TStaticText;
    GroupBox2: TGroupBox;
    HtmlDirTree: TDirectoryListBox;
    HtmlPath: TLabeledEdit;
    HtmlOkBtn: TButton;
    HtmlCloseBtn: TButton;
    procedure Form2Close(Sender: TObject; var Action: TCloseAction);
    procedure HtmlCreate(Sender: TObject);
    procedure HtmlOkClick(Sender: TObject);
    procedure HtmlCloseClick(Sender: TObject);
    procedure HtmlDirChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses FileListModule;

{$R *.dfm}

procedure TForm2.Form2Close(Sender: TObject; var Action: TCloseAction);
begin
  Form1.Enabled:=true;
end;

procedure TForm2.HtmlCreate(Sender: TObject);
begin
  Memo1.Lines.LoadFromFile('html.txt');
  HtmlPath.Text:=HtmlDirTree.Directory;
end;

procedure TForm2.HtmlOkClick(Sender: TObject);
begin
  Form1.HtmlPathEdit.Text:=HtmlPath.Text;
  Memo1.Lines.SaveToFile('html.txt');
  Form2.Close;
end;
procedure TForm2.HtmlCloseClick(Sender: TObject);
begin
  Form2.Close;
end;

procedure TForm2.HtmlDirChange(Sender: TObject);
begin
  HtmlPath.Text:=HtmlDirTree.Directory;
end;

end.
