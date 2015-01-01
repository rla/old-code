unit AddDEfault;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm4 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    procedure CancelDefault(Sender: TObject);
    procedure OkDefault(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

uses Algus;

{$R *.dfm}

procedure TForm4.CancelDefault(Sender: TObject);
begin
  Form4.Close;
end;

procedure TForm4.OkDefault(Sender: TObject);
begin
  Algus.Form1.ListBox1.Items.Add(Edit1.Text);
end;

end.
