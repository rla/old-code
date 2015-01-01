unit Settingud;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ExtCtrls;

const setnimi='settingud.txt';

type
  TSetForm = class(TForm)
    Label1: TLabel;
    SetList: TCheckListBox;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    procedure StartSet(Sender: TObject);
    procedure CloseSet(Sender: TObject; var Action: TCloseAction);
    procedure TagasiClk(Sender: TObject);
    procedure SetOk(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SetForm: TSetForm;

implementation

uses KuhuInst, SpecSet;

{$R *.dfm}

procedure TSetForm.StartSet(Sender: TObject);
var
  sfile:TextFile;
  title:string;
  ptitle:string;
  rida:string;
  stiil:byte;
  i:integer;
begin
  Memo1.Clear;
  SetList.Clear;
  AssignFile(sfile, setnimi);
  Reset(sfile);
  ReadLn(sfile, title);
  ReadLn(sfile, ptitle);

  repeat
    ReadLn(sfile, rida);
    if rida<>'1111' then SetList.Items.Add(rida);
  until rida='1111';
  repeat
    ReadLn(sfile, rida);
    if rida<>'2222' then Memo1.Lines.Add(rida);
  until rida='2222';
  ReadLn(sfile, rida);
  Button1.Caption:=rida;
  ReadLn(sfile, rida);
  Button2.Caption:=rida;
  Label1.Caption:=ptitle;
  SetForm.Caption:=title;
  Application.Title:=title;
  CloseFile(sfile);
end;

procedure TSetForm.CloseSet(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TSetForm.TagasiClk(Sender: TObject);
begin
  KuhuInst.KuhuForm.Show;
  SetForm.Hide;
end;

procedure TSetForm.SetOk(Sender: TObject);
var
  sfile:TextFile;
  i:integer;
begin
  AssignFile(sfile, 'installer.log');
  Append(sfile);
  WriteLn(sfile, 'Paketid {');
  for i:=0 to SetList.Items.Count-1 do
  begin
    if SetList.Checked[i] then WriteLn(sfile, SetList.Items.Strings[i]);
  end;
  WriteLn(sfile, '}');
  CloseFile(sfile);
  SetForm.Hide;
  SpecSet.SpecForm.Show;
end;

end.
