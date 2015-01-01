program CssEdit;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  AddClass in 'AddClass.pas' {Form2},
  Copyright in 'Copyright.pas' {Form3},
  CSSParser in 'CSSParser.pas',
  Debug in 'Debug.pas' {Form4},
  CSSClass in 'CSSClass.pas',
  CSSNode in 'CSSNode.pas',
  CSSStatement in 'CSSStatement.pas',
  CSSMedium in 'CSSMedium.pas',
  CSSList in 'CSSList.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Css Editor';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
