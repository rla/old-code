unit FilesListDest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm3 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure CancDest(Sender: TObject);
    procedure DestOk(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses FilesList;

{$R *.dfm}

procedure TForm3.CancDest(Sender: TObject);
begin
  Form3.Close;
end;

procedure TForm3.DestOk(Sender: TObject);
begin
  FilesList.Form2.ListBox1.Items.Add(FilesList.Form2.FileListBox1.FileName+ ' -> ' +Edit1.Text +ExtractFileName(FilesList.Form2.FileListBox1.FileName));
  Form3.Close;
end;

end.
