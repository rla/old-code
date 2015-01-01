unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, StdCtrls, ComCtrls, OleCtrls, SHDocVw, Buttons,
  DB, DBTables;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Fail1: TMenuItem;
    Lisa1: TMenuItem;
    Aine1: TMenuItem;
    Peatkk1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    TreeView1: TTreeView;
    Button1: TButton;
    Panel3: TPanel;
    Label2: TLabel;
    Panel4: TPanel;
    WebBrowser1: TWebBrowser;
    Button2: TButton;
    PopupMenu1: TPopupMenu;
    Lisapeatkk1: TMenuItem;
    StatusBar1: TStatusBar;
    OpenDialog1: TOpenDialog;
    Fail2: TMenuItem;
    Salvesta1: TMenuItem;
    N1: TMenuItem;
    Vlju1: TMenuItem;
    SpeedButton1: TSpeedButton;
    Bevel1: TBevel;
    SpeedButton2: TSpeedButton;
    eeFail1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Lisapeatkk1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure TreeDblClick(Sender: TObject);
    procedure UusFail(Sender: TObject);
    procedure Salvesta1Click(Sender: TObject);
    procedure CloseForm(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure eeFail1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ProgDir: string;

implementation

uses
  LisaAine, UusFail;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Form2.ShowModal;
end;

procedure TForm1.Lisapeatkk1Click(Sender: TObject);

begin
  if TreeView1.Selected.Parent=nil then TreeView1.Items.AddChild(TreeView1.Selected, 'jee');
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TreeView1.SaveToFile(ProgDir +'puu.puu');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TreeView1.LoadFromFile(ProgDir +'puu.puu');
  ProgDir:=ExtractFilePath(ParamStr(0));
end;

procedure TForm1.TreeDblClick(Sender: TObject);
var
  fnimi: string;
begin
  if TreeView1.Selected.Parent=nil then fnimi:=ProgDir +'andmed\' +IntToStr(TreeView1.Selected.Index) +'.html'
    else fnimi:=ProgDir +'andmed\' +IntToStr(TreeView1.Selected.Parent.Index) +'_' +IntToStr(TreeView1.Selected.Index) +'.html';
  if FileExists(fnimi) then WebBrowser1.Navigate(fnimi)
    else WebBrowser1.Navigate(ProgDir +'andmed\error_01.html');
end;

procedure TForm1.UusFail(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    if TreeView1.Selected.Parent=nil then CopyFile(PChar(OpenDialog1.FileName), PChar(ProgDir +'andmed\' +IntToStr(TreeView1.Selected.Index) +'.html'), false)
      else CopyFile(PChar(OpenDialog1.Filename), PChar(ProgDir +'andmed\' +IntToStr(TreeView1.Selected.Parent.Index) +'_' +IntToStr(TreeView1.Selected.Index) +'.html'), false);
  end;
end;

procedure TForm1.Salvesta1Click(Sender: TObject);
begin
  TreeView1.SaveToFile(ProgDir +'puu.puu');
end;

procedure TForm1.CloseForm(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  TreeView1.SaveToFile(ProgDir +'puu.puu');
end;

procedure TForm1.eeFail1Click(Sender: TObject);
begin
  if TreeView1.Selected.Parent=nil then Faili_nimi:=ProgDir +'andmed\' +IntToStr(TreeView1.Selected.Index) +'.html'
    else Faili_nimi:=ProgDir +'andmed\' +IntToStr(TreeView1.Selected.Parent.Index) +'_' +IntToStr(TreeView1.Selected.Index) +'.html';
  Form3.ShowModal;
end;

end.
