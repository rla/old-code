unit SpecSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

const specfile='special.txt';

type
  TSpecForm = class(TForm)
    Group: TGroupBox;
    cb1: TCheckBox;
    cb2: TCheckBox;
    cb3: TCheckBox;
    cb4: TCheckBox;
    procedure SpecClose(Sender: TObject; var Action: TCloseAction);
    procedure ShowSpec(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SpecForm: TSpecForm;

implementation

{$R *.dfm}

procedure TSpecForm.SpecClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TSpecForm.ShowSpec(Sender: TObject);
var
  sfile:TextFile;
  rida:string;
  i:integer;
begin
  AssignFile(sfile, specfile);
  Reset(sfile);
  ReadLn(sfile, rida);
  Application.Title:=rida;
  SpecForm.Caption:=rida;

  ReadLn(sfile, rida);
  Group.Caption:=rida;

  i:=1;
  repeat
    ReadLn(sfile, rida);
    if rida<>'3333' then
    case i of
      1:begin
        cb1.Visible:=true; cb1.Caption:=rida;
        end;
      2:begin
        cb2.Visible:=true; cb2.Caption:=rida;
        end;
      3:begin
        cb3.Visible:=true; cb3.Caption:=rida;
        end;
      4:begin
        cb4.Visible:=true; cb4.Caption:=rida;
        end;
    end;{case}
    inc(i);    
  until pos('3333', rida)>0;

  CloseFile(sfile);
end;

end.
