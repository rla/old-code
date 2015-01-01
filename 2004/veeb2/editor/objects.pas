unit Objects;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids;

type
  TForm2 = class(TForm)
    StringGrid1: TStringGrid;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation
uses Main;

{$R *.dfm}

procedure TForm2.FormShow(Sender: TObject);
var
  F: file of objektikirje;
  i: word;
  obj: objektikirje;
begin
  AssignFile(F, Form1.Edit1.Text);
  Reset(F);
  for i:=0 to FileSize(F)-1 do
  begin
    Read(F, obj);
    StringGrid1.Cells[0, i]:=obj.nimi;
    if obj.tyyp=html then StringGrid1.Cells[1, i]:='HTML'
    else StringGrid1.Cells[1, i]:='THTML'
  end;
  CloseFile(F);
end;

end.
