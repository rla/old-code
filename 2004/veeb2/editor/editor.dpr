program editor;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  Objects in 'Objects.pas' {Form2},
  Code in 'Code.pas' {Form3},
  Data in 'Data.pas' {Form4},
  Lang in 'Lang.pas' {Form5};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
