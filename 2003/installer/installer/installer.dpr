program Installer;

uses
  Forms,
  CopyForm in 'CopyForm.pas' {Form1},
  Splash in 'Splash.pas' {Form2},
  Where in 'Where.pas' {Form3},
  SetForm in 'SetForm.pas' {Form4},
  Special in 'Special.pas' {Form5},
  DoInstall in 'DoInstall.pas' {Form6},
  RegistrySys in 'RegistrySys.pas' {Form7};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm7, Form7);
  Application.Run;
end.
