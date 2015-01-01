unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl, Grids, Outline, DirOutln, ActnList, StrUtils,
  Menus, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Author1: TMenuItem;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    StringGrid1: TStringGrid;
    Button6: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    GroupBox2: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Button5: TButton;
    Button7: TButton;
    Panel3: TPanel;
    DirectoryListBox1: TDirectoryListBox;
    FileListBox1: TFileListBox;
    Panel4: TPanel;
    DriveComboBox1: TDriveComboBox;
    Panel5: TPanel;
    Label5: TLabel;
    procedure ChangeDrive(Sender: TObject);
    procedure ChangeDir(Sender: TObject);
    procedure ListBoxMp3DblClick(Sender: TObject);
    procedure ShowingForm(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Author1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  lasttag: byte;
  lastfile: TFileName;
  lastartist: string;
  lasttitle: string;

implementation

uses
  ID3Tag, Version;

{$R *.dfm}

procedure TForm1.ChangeDrive(Sender: TObject);
begin
  DirectoryListBox1.Drive:=DriveCombobox1.Drive;
end;

procedure TForm1.ChangeDir(Sender: TObject);
begin
  FileListBox1.Directory:=DirectoryListBox1.Directory;
  Label5.Caption:=DirectoryListBox1.Directory;
end;

procedure TForm1.ListBoxMp3DblClick(Sender: TObject);
var
  ID3Tag:TID3Tag;
  artist:string;
  title:string;
begin
  GetID3Tag(FileListBox1.FileName, ID3Tag);
  lastfile:=FileListBox1.FileName;
  artist:=trim(Id3Tag.Artist);
  title:=trim(Id3Tag.Titel);
  StringGrid1.Cells[1,0]:=title;
  StringGrid1.Cells[1,1]:=artist;
  StringGrid1.Cells[1,2]:=trim(Id3Tag.Album);
  StringGrid1.Cells[1,3]:=trim(Id3Tag.Year);
  StringGrid1.Cells[1,4]:=trim(Id3Tag.Comment);
  lasttag:=id3tag.Genre;
  Edit1.Text:=artist;
  Edit2.Text:=trim(Id3Tag.Album);
  Edit3.Text:=trim(Id3Tag.Year);
  Edit4.Text:=trim(Id3Tag.Comment);
  Edit5.Text:=ExtractFileName(FileListBox1.FileName);
  Edit6.Text:=artist +' - ' +title +'.mp3';
  Button5.Enabled:=true;
  Button7.Enabled:=true;
  lastartist:=artist;
  lasttitle:=title;
end;

procedure TForm1.ShowingForm(Sender: TObject);
begin
  StringGrid1.Cells[0,0]:='Title';
  StringGrid1.Cells[0,1]:='Artist';
  StringGrid1.Cells[0,2]:='Album';
  StringGrid1.Cells[0,3]:='Year';
  StringGrid1.Cells[0,4]:='Comment';
  StringGrid1.ColWidths[1]:=191;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  id3tag:Tid3tag;
  i:integer;
  directory:string;
begin
  directory:=DirectoryListBox1.Directory;
  if directory[length(directory)]<>'/' then directory:=directory +'/';
  for i:=0 to FileListBox1.Count-1 do
  begin
    GetId3Tag(directory +FileListBox1.Items.Strings[i], id3tag);
    FillChar(id3tag.Artist, 31, ' ');
    id3tag.artist:=Edit1.Text;
    SetId3Tag(directory +FileListBox1.Items.Strings[i], id3tag);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  id3tag:Tid3tag;
  i:integer;
  directory:string;
begin
  directory:=DirectoryListBox1.Directory;
  if directory[length(directory)]<>'/' then directory:=directory +'/';
  for i:=0 to FileListBox1.Count-1 do
  begin
    GetId3Tag(directory +FileListBox1.Items.Strings[i], id3tag);
    FillChar(id3tag.Album, 31, ' ');
    id3tag.album:=Edit2.Text;
    SetId3Tag(directory +FileListBox1.Items.Strings[i], id3tag);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  id3tag:Tid3tag;
  i:integer;
  directory:string;
begin
  directory:=DirectoryListBox1.Directory;
  if directory[length(directory)]<>'/' then directory:=directory +'/';
  for i:=0 to FileListBox1.Count-1 do
  begin
    GetId3Tag(directory +FileListBox1.Items.Strings[i], id3tag);
    FillChar(id3tag.year, 5, ' ');
    id3tag.year:=Edit3.Text;
    SetId3Tag(directory +FileListBox1.Items.Strings[i], id3tag);
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  id3tag:Tid3tag;
  i:integer;
  directory:string;
begin
  directory:=DirectoryListBox1.Directory;
  if directory[length(directory)]<>'/' then directory:=directory +'/';
  for i:=0 to FileListBox1.Count-1 do
  begin
    GetId3Tag(directory +FileListBox1.Items.Strings[i], id3tag);
    FillChar(id3tag.comment, 31, ' ');
    id3tag.comment:=Edit4.Text;
    SetId3Tag(directory +FileListBox1.Items.Strings[i], id3tag);
  end;

end;

procedure TForm1.Button5Click(Sender: TObject);
var
  directory:string;
begin
  directory:=DirectoryListBox1.Directory;
  if directory[length(directory)]<>'/' then directory:=directory +'/';
  RenameFile(directory +Edit5.Text, directory +Edit6.Text);
  lastfile:=directory +Edit6.Text;
  FileListBox1.Update;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  id3tag:Tid3tag;
  directory:string;
begin
  directory:=DirectoryListBox1.Directory;
  if directory[length(directory)]<>'/' then directory:=directory +'/';
  id3tag.ID:='TAG';
  FillChar(id3tag.Titel, 31, ' ');
  id3tag.Titel:=StringGrid1.Cells[1,0];
  FillChar(id3tag.Artist, 31, ' ');
  id3tag.Artist:=StringGrid1.Cells[1,1];
  FillChar(id3tag.Album, 31, ' ');
  id3tag.Album:=StringGrid1.Cells[1,2];
  FillChar(id3tag.Year, 5, ' ');
  id3tag.Year:=StringGrid1.Cells[1,3];
  FillChar(id3tag.Comment, 31, ' ');
  id3tag.Comment:=StringGrid1.Cells[1,4];
  id3tag.Genre:=lasttag;
  SetId3Tag(lastfile, id3tag);
  Button5.Enabled:=true;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  DeleteFile(lastfile);
  FileListBox1.Update;
  Button5.DisableAlign;
end;

procedure TForm1.Button8Click(Sender: TObject);
var
  krpos:byte;
  fname:string;
begin
  fname:=ExtractFileName(FileListBox1.FileName);
  krpos:=pos('-', fname);
  if krpos>0 then
  begin
    StringGrid1.Cells[1,0]:=AnsiReplaceStr(trim(copy(fname, krpos+1, length(fname)-krpos-4)), '_', ' ');
    Edit6.Text:=lastartist +' - ' +StringGrid1.Cells[1,0] +'.mp3';
    lasttitle:=StringGrid1.Cells[1,0];
  end;
  Button5.Enabled:=false;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  StringGrid1.Cells[1,0]:='';
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  StringGrid1.Cells[1,1]:='';
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  StringGrid1.Cells[1,2]:='';
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
  StringGrid1.Cells[1,3]:='';
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
  StringGrid1.Cells[1,4]:='';
end;

procedure TForm1.Button14Click(Sender: TObject);
var
  krpos:byte;
  fname:string;
begin
  fname:=ExtractFileName(FileListBox1.FileName);
  krpos:=pos('-', fname);
  if krpos>0 then
  begin
    StringGrid1.Cells[1,1]:=AnsiReplaceStr(trim(copy(fname, 1, krpos-1)), '_', ' ');
    Edit6.Text:=StringGrid1.Cells[1,1] +' - ' +lasttitle +'.mp3';
    lastartist:=StringGrid1.Cells[1,1];
  end;
end;

procedure TForm1.Author1Click(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Form1.Close;
end;

end.
