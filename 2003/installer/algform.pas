unit AlgForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

const
  copynimi='copyright.txt';
  formnimi='copyform.txt';

type
  TCopyForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CopyMemo: TMemo;
    procedure ShowMemo(Sender: TObject);
    procedure OkClk(Sender: TObject);
    procedure Valju(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CopyForm: TCopyForm;

implementation

uses KuhuInst;

{$R *.dfm}

procedure TCopyForm.ShowMemo(Sender: TObject);
var
  cfile:TextFile;
  title:string;
  okcaption:string;
  canccaption:string;
begin
  if FileExists(copynimi) then CopyMemo.Lines.LoadFromFile(copynimi);
  if FileExists(formnimi) then
  begin
    AssignFile(cfile, formnimi);
    Reset(cfile);
    ReadLn(cfile, title); //pealkiri
    ReadLn(cfile, okcaption); //'Agree'
    ReadLn(cfile, canccaption);//'Disagree'
    Button1.Caption:=okcaption;
    Button2.Caption:=canccaption;
    CopyForm.Caption:=title;
    Application.Title:=title;
    CloseFile(cfile);
  end;

end;

procedure TCopyForm.OkClk(Sender: TObject);
begin
  KuhuInst.KuhuForm.Show;
  CopyForm.Destroy;
end;

procedure TCopyForm.Valju(Sender: TObject);
begin
  CopyForm.Close;
end;

end.
