unit FilesList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl;

type
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    DirectoryListBox1: TDirectoryListBox;
    FileListBox1: TFileListBox;
    Button1: TButton;
    GroupBox2: TGroupBox;
    ListBox1: TListBox;
    Button2: TButton;
    Button3: TButton;
    procedure ChangeSDir(Sender: TObject);
    procedure LisaFailid(Sender: TObject);
    procedure FilesListCanc(Sender: TObject);
    procedure FilesListOk(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  flist: TStrings;

implementation

uses FilesListDest, Algus;

{$R *.dfm}

procedure TForm2.ChangeSDir(Sender: TObject);
begin
  FileListBox1.Directory:=DirectoryListBox1.Directory;
end;

procedure TForm2.LisaFailid(Sender: TObject);
begin
  FilesListDest.Form3.ShowModal;
end;

procedure TForm2.FilesListCanc(Sender: TObject);
begin
  Form2.Close;
end;

procedure TForm2.FilesListOk(Sender: TObject);
var
  ii:integer;
  dirpath:string;
begin
  dirpath:=trim(Algus.Form1.Edit6.Text);
  if copy(dirpath,length(dirpath),1)<>'\' then dirpath:=dirpath+'\';
  ii:=Algus.Form1.CheckListBox1.ItemIndex;
  ListBox1.Items.SaveToFile(dirpath+'list' +IntToStr(ii)+'.lst');
  Form2.Close;
end;

end.
