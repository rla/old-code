unit Code;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SynEditHighlighter, SynHighlighterHtml, ExtCtrls,
  SynEdit, SynHighlighterCss;

type
  TForm3 = class(TForm)
    SynEdit1: TSynEdit;
    Panel1: TPanel;
    SynHTMLSyn1: TSynHTMLSyn;
    Button1: TButton;
    Button2: TButton;
    SynCssSyn1: TSynCssSyn;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  codefile: string;

implementation

{$R *.dfm}

procedure TForm3.Button2Click(Sender: TObject);
begin
  Form3.Close;
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
  SynEdit1.Lines.SaveToFile(codefile);
end;

end.
