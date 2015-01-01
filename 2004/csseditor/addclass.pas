unit AddClass;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm2 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
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

procedure TForm2.Button1Click(Sender: TObject);
begin
  class_list.Add(Edit1.Text +'{}');
  //Form1.ListBox1.Items.Add(Edit1.Text);
  Form2.Close;
end;

end.
