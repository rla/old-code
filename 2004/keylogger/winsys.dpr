program winsys;

uses
  Forms,
  Main in 'Main.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'winsys';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
