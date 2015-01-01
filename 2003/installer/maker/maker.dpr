program Maker;

uses
  Forms,
  Algus in 'Algus.pas' {Form1},
  FilesList in 'FilesList.pas' {Form2},
  FilesListDest in 'FilesListDest.pas' {Form3},
  DefFList in 'DefFList.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
