unit Lang;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm5 = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;
  keel: string;

implementation

{$R *.dfm}

procedure TForm5.Button1Click(Sender: TObject);
begin
  if ListBox1.ItemIndex>=0 then
  begin
    keel:=ListBox1.Items.Strings[ListBox1.ItemIndex];
    Form5.Close;
  end;
end;

end.
