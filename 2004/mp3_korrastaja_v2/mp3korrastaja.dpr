program Mp3Korrastaja;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  ID3Tag in 'ID3Tag.pas',
  Version in 'Version.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Mp3Id3Fix';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
