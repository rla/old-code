unit FileListModule;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ToolWin, ComCtrls, ShellCtrls, StdCtrls, ExtCtrls, IniFiles;

type
  TForm1 = class(TForm)
    KaustaPuu: TShellTreeView;
    Laiendid: TGroupBox;
    mp3chk: TCheckBox;
    avichk: TCheckBox;
    oggchk: TCheckBox;
    GroupBox2: TGroupBox;
    JuurEdit: TEdit;
    StatusGroup: TGroupBox;
    Status: TLabel;
    List: TGroupBox;
    listtxtchk: TCheckBox;
    TxtPath: TEdit;
    Otsitxt: TButton;
    OpenTxt: TOpenDialog;
    StartBtn: TButton;
    ExitBtn: TButton;
    KaustagaChk: TCheckBox;
    ParandaChk: TCheckBox;
    wadchk: TCheckBox;
    HtmlBtn: TButton;
    HtmlPathEdit: TEdit;
    htmlchk: TCheckBox;
    procedure JuurMuutus(Sender: TObject; Node: TTreeNode);
    procedure ListChkClick(Sender: TObject);
    procedure OtsiTxtClick(Sender: TObject);
    procedure valju(Sender: TObject);
    procedure StartClick(Sender: TObject);
    procedure GetFileList(gjuur:string; kaust:boolean);
    procedure Write2Txt(fnimi:string; List:TStrings; paranda:boolean);
    procedure HtmlClick(Sender: TObject);
    procedure HtmlChkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  fjuur:string;//juur
  FileNList:TStringList;
  DirList:TStrings;

implementation

uses HTMLForm;

{$R *.dfm}

function CompareStr(List: TStringList; Index1, Index2: Integer): Integer;
var 
  d1,d2:string;
begin
  d1:=List.Strings[Index1];
  d2:=List.Strings[Index2];
  if d1<d2 then
    Result:=-1
  else if d1>d2 then Result:=1
  else
    Result:=0;
end;

function RepairPr(s:string):string;
begin
  RepairPr:=StringReplace(s, '_', ' ', [rfReplaceAll, rfIgnoreCase]);
end;

procedure Write2HTML(dir:string; List:TStrings; paranda:boolean);
var
  txtfile:TextFile;
  headfile:TextFile;
  algusbuff:string;
  loppbuff:string;
  rida:string;
  alg:boolean;
  countch:char;
  i:integer;
begin
  algusbuff:='';
  loppbuff:='';
  alg:=true;
  AssignFile(headfile, 'html.txt');
  Reset(headfile);

  while not(eof(headfile)) do //html algus,lõpu saamine
  begin
    readln(headfile, rida);
    if pos('%nimekiri', rida)=0 then
    begin
      if alg then algusbuff:=algusbuff+rida
        else loppbuff:=loppbuff+rida;
    end
    else alg:=false;
  end;
  CloseFile(headfile);

  for countch:='a' to 'z' do //html a-st z-ni
  begin
    AssignFile(txtfile, dir +'\' +countch +'.html');
    Rewrite(txtfile);
    writeln(txtfile, algusbuff);
    for i:=0 to FileNList.Count-1 do
    begin
      rida:=LowerCase(FileNList[i]);
      if (copy(rida, 1, 1)=countch) and (length(rida)>8) then writeln(txtfile, copy(rida,1 ,length(rida)-4) +'<br>');
    end;
    writeln(txtfile, loppbuff);
    CloseFile(txtfile);
  end;
end;//write2html

procedure TForm1.Write2Txt(fnimi:string; List:TStrings; paranda:boolean);
var
  txtfile:TextFile;
  i:integer;
  rida:string;
begin
  if length(fnimi)<1 then ShowMessage('Tekstifaili nimi:error.')
  else
  begin
    AssignFile(txtfile, fnimi);
    Rewrite(txtfile);
    for i:=0 to List.Count-1 do
    begin
      if paranda then rida:=RepairPr(List[i])
        else rida:=List[i];
      if (mp3chk.Checked) and (UpperCase(copy(rida, length(rida)-3, 4))='.MP3') then writeln(txtfile, LowerCase(rida));
      if (avichk.Checked) and (UpperCase(copy(rida, length(rida)-3, 4))='.AVI') then writeln(txtfile, LowerCase(rida));
      if (oggchk.Checked) and (UpperCase(copy(rida, length(rida)-3, 4))='.OGG') then writeln(txtfile, LowerCase(rida));
      if (wadchk.Checked) and (UpperCase(copy(rida, length(rida)-3, 4))='.WAD') then writeln(txtfile, LowerCase(rida));
    end;
    CloseFile(txtfile);
  end;
end;

procedure TForm1.GetFileList(gjuur:string; kaust:boolean);
var
  sr:TSearchRec;
begin
  FindFirst(gjuur + '*.*', faArchive , sr);
  if length(sr.Name)>0 then
  begin
    if kaust then //kui kaust true lisatakse terve path
    begin
      FileNList.Add(gjuur +sr.Name);
      while FindNext(sr)=0 do
        FileNList.Add(gjuur +sr.Name);
    end
    else //kui kaust false siis lisatakse ainult faili nimi
    begin
      FileNList.Add(sr.Name);
      while FindNext(sr)=0 do
        FileNList.Add(sr.Name);
    end;
  end;
  FindClose(sr);
end;//GetFileList

procedure GetChildFolders(Root: string; List: TStrings);
   procedure GetAllChildrenOf(TempRoot: string);
    var
    sr: TSearchRec;
    begin
      if FindFirst(TempRoot + '*.*', faDirectory, sr) = 0 then
      begin
        if (sr.Attr = faDirectory) and (sr.Name <> '.') and (sr.Name <> '..') then
          List.Add(TempRoot + sr.Name + '\');
        while FindNext(sr) = 0 do
          if (sr.Attr = faDirectory) and (sr.Name <> '.') and (sr.Name <> '..') then
            List.Add(TempRoot + sr.Name + '\');
        FindClose(sr);
      end;
    end;

var
sRoot:  string;
iIndex: integer;
begin
  if Root[Length(Root)] <> '\' then
    sRoot := Root + '\'  //add trailing backslash
  else
    sRoot := Root;

  iIndex := List.Count; //set counter to reduce number of times to what's necessary
  GetAllChildrenOf(sRoot);  //get first level of child folders
  while iIndex < List.Count-1 do  //while there remains more items
  begin
    sRoot := List.Strings[iIndex];  //reset root to next item in list
    Inc(iIndex);  //increment counter
    GetAllChildrenOf(sRoot);  //get next level of child folders
  end;
end;

procedure TForm1.JuurMuutus(Sender: TObject; Node: TTreeNode);
begin
  JuurEdit.Text:=KaustaPuu.Path;
end;

procedure TForm1.ListChkClick(Sender: TObject);
begin
  if listtxtchk.Checked then
    begin
    txtpath.Enabled:=true;
    txtpath.Color:=clWindow;
    end
    else
    begin
    txtpath.Enabled:=false;
    txtpath.Color:=clSilver;
    end;
end;

procedure TForm1.OtsiTxtClick(Sender: TObject);
var
  fnimi:string;
begin
  if listtxtchk.Checked then
    if OpenTxt.Execute then
      begin
      fnimi:=OpenTxt.FileName;
      if copy(fnimi, length(fnimi)-3, 4)<>'.txt' then fnimi:=fnimi +'.txt';
      TxtPath.Text:=fnimi;
      end;
end;

procedure TForm1.valju(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.StartClick(Sender: TObject);
var
  i:integer;
begin
  FileNList:=TStringList.Create;
  DirList:=TStringList.Create;

  Status.Caption:='Kaustapuu tekitamine...';
  GetChildFolders(JuurEdit.Text, DirList);
  DirList.Add(JuurEdit.Text +'\');
  Status.Caption:='Kaustapuu...ok';

  for i:=0 to DirList.Count-1 do GetFileList(DirList.Strings[i], KaustagaChk.Checked);//Failide nimekirja saamine
  FileNList.CustomSort(CompareStr);
  Status.Caption:='Failide nimekiri..ok';

  if listtxtchk.Checked then
  begin
    Status.Caption:='Tekstifaili kirjutamine';
    Write2Txt(TxtPath.Text, FileNList, ParandaChk.Checked);//tekstifaili kirjutamine
  end;

  if htmlchk.Checked then
  begin
    Status.Caption:='HTML tegemine';
    Write2HTML(HtmlPathEdit.Text, FileNList, ParandaChk.Checked);
  end;

  Status.Caption:='...OK';
  DirList.Free;
  FileNList.Free;
end;

procedure TForm1.HtmlClick(Sender: TObject);
begin
  if htmlchk.Checked then
  begin
    Form2.Visible:=true;
    Form1.Enabled:=false;
  end;  
end;

procedure TForm1.HtmlChkClick(Sender: TObject);
begin
  if htmlchk.Checked then
    begin
      HtmlPathEdit.Color:=clWindow;
      HtmlPathEdit.Enabled:=true;
    end
    else
    begin
      HtmlPathEdit.Color:=clSilver;
      HtmlPathEdit.Enabled:=false;
    end;
end;

end.
