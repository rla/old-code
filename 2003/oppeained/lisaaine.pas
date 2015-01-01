unit LisaAine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm2 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Button2: TButton;
    Button3: TButton;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses
  MainForm;

{$R *.dfm}

procedure TForm2.Button3Click(Sender: TObject);
begin
  Form2.Close;
end;

procedure TForm2.Button2Click(Sender: TObject);
var i:integer;
begin
  Form1.TreeView1.Items.AddChild(nil, Edit1.Text);
  i:=Form1.TreeView1.Items.Count;
  ShowMessage(IntToStr(i));
  Form2.Close;
end;

end.
