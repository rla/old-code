program FileList;

uses
  Forms,
  FileListModule in 'FileListModule.pas' {Form1},
  HTMLForm in 'HTMLForm.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
