unit KuhuInst;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ShellCtrls, Grids, Outline, DirOutln;

const kuhunimi='kuhu.txt';  

type
  TKuhuForm = class(TForm)
    PathEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    DirList: TShellTreeView;
    procedure KuhuStart(Sender: TObject);
    procedure KuhuClose(Sender: TObject; var Action: TCloseAction);
    procedure KuhuCanc(Sender: TObject);
    procedure MuudaPath(Sender: TObject);
    procedure KuhuOk(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  KuhuForm: TKuhuForm;

implementation

uses Settingud;

{$R *.dfm}

procedure TKuhuForm.KuhuStart(Sender: TObject);
var
  kfile:TextFile;
  title:string;
  path:string;
  ptitle:string;
  vspace:string;
  ccaption:string;
  ncaption:string;
begin
  AssignFile(kfile, kuhunimi);
  Reset(kfile);
  ReadLn(kfile, title);
  ReadLn(kfile, ptitle);
  ReadLn(kfile, path);
  ReadLn(kfile, vspace);
  ReadLn(kfile, ccaption);
  ReadLn(kfile, ncaption);
  Button2.Caption:=ncaption;
  Button1.Caption:=ccaption;
  Label1.Caption:=ptitle;
  Label2.Caption:=vspace;
  PathEdit.Text:=path;
  KuhuForm.Caption:=title;
  Application.Title:=title;
  CloseFile(kfile);
end;

procedure TKuhuForm.KuhuClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TKuhuForm.KuhuCanc(Sender: TObject);
begin
  KuhuForm.Close;
end;

procedure TKuhuForm.MuudaPath(Sender: TObject);
begin
  PathEdit.Text:=DirList.Path;
end;

procedure TKuhuForm.KuhuOk(Sender: TObject);
var
  kfile:TextFile;
begin
  AssignFile(kfile, 'installer.log');
  Rewrite(kfile);
  WriteLn(kfile, 'Path=' +PathEdit.Text);
  CloseFile(kfile);
  ForceDirectories(PathEdit.Text);
  KuhuForm.Hide;
  Settingud.SetForm.Show;
end;

end.
