unit Data;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ValEdit, ExtCtrls, Menus;

type
  TForm4 = class(TForm)
    Panel1: TPanel;
    ValueListEditor1: TValueListEditor;
    Button1: TButton;
    Button2: TButton;
    PopupMenu1: TPopupMenu;
    Insertnew1: TMenuItem;
    procedure Insertnew1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;
  datafile: string;

implementation
uses Main;

{$R *.dfm}

procedure TForm4.Insertnew1Click(Sender: TObject);
begin
  ValueListEditor1.InsertRow('new', 'new value', true);
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
  Form4.Close;
end;

procedure TForm4.Button1Click(Sender: TObject);
var
  andmed: file of andmekirje;
  data: andmekirje;
  i: word;
begin
  AssignFile(andmed, datafile);
  Reset(andmed);
  for i:=1 to ValueListEditor1.RowCount-1 do
  begin
    data.nimi:=ValueListEditor1.Cells[0, i];
    data.vaartus:=ValueListEditor1.Cells[1, i];
    Write(andmed, data);
  end;
  CloseFile(andmed);
end;

procedure TForm4.FormClose(Sender: TObject; var Action: TCloseAction);
var i: word;
begin
  for i:=ValueListEditor1.RowCount-1 downto 1 do ValueListEditor1.DeleteRow(i);
end;

end.
