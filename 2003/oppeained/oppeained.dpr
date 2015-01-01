program Oppeained;

uses
  Forms,
  MainForm in 'MainForm.pas' {Form1},
  LisaAine in 'LisaAine.pas' {Form2},
  UusFail in 'UusFail.pas' {Form3},
  rtf2html in 'rtf2html.pas',
  HTMLEncode in 'HTMLEncode.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
