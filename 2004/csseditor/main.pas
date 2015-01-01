unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Menus, ExtCtrls, Grids, Buttons, ToolWin,
  ImgList, CSSParser, CSSList;


type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    OpenDialog1: TOpenDialog;
    Open1: TMenuItem;
    Append1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    PopupMenu1: TPopupMenu;
    fontfamily1: TMenuItem;
    fontweight1: TMenuItem;
    background1: TMenuItem;
    fontsize1: TMenuItem;
    fontvariant1: TMenuItem;
    fontstrecth1: TMenuItem;
    fontsizeadjust1: TMenuItem;
    font1: TMenuItem;
    textindent1: TMenuItem;
    textalign1: TMenuItem;
    Font2: TMenuItem;
    ext1: TMenuItem;
    textdecoration1: TMenuItem;
    textshadow1: TMenuItem;
    letterspacing1: TMenuItem;
    wordspacing1: TMenuItem;
    texttransform1: TMenuItem;
    whitespace1: TMenuItem;
    ables1: TMenuItem;
    captionside1: TMenuItem;
    tablelayout1: TMenuItem;
    bordercollapse1: TMenuItem;
    borderspacing1: TMenuItem;
    emptycells1: TMenuItem;
    borderstyle1: TMenuItem;
    speakheader1: TMenuItem;
    Ui1: TMenuItem;
    cursor1: TMenuItem;
    outline1: TMenuItem;
    outlinewidth1: TMenuItem;
    outlinestyle1: TMenuItem;
    outlinecolor1: TMenuItem;
    focus1: TMenuItem;
    active1: TMenuItem;
    Aural1: TMenuItem;
    volume1: TMenuItem;
    voicefamily1: TMenuItem;
    stress1: TMenuItem;
    richness1: TMenuItem;
    cuebefore1: TMenuItem;
    azimuth1: TMenuItem;
    speak1: TMenuItem;
    pausebefore1: TMenuItem;
    pauseafter1: TMenuItem;
    pause1: TMenuItem;
    cueafter1: TMenuItem;
    cue1: TMenuItem;
    playduring1: TMenuItem;
    elevation1: TMenuItem;
    speechrate1: TMenuItem;
    pitch1: TMenuItem;
    pitchrange1: TMenuItem;
    speakpunctuctation1: TMenuItem;
    speaknumeral1: TMenuItem;
    Background2: TMenuItem;
    backgroundattachment1: TMenuItem;
    backgroundcolor1: TMenuItem;
    backgroundimage1: TMenuItem;
    backgroundposition1: TMenuItem;
    backgroundrepeat1: TMenuItem;
    Border1: TMenuItem;
    border2: TMenuItem;
    bordercollapse2: TMenuItem;
    bordercolor1: TMenuItem;
    borderspacing2: TMenuItem;
    borderstyle2: TMenuItem;
    bordertop1: TMenuItem;
    borderleft1: TMenuItem;
    borderright1: TMenuItem;
    borderbottom1: TMenuItem;
    bordertopcolor1: TMenuItem;
    borderleftcolor1: TMenuItem;
    borderrightcolor1: TMenuItem;
    borderbottomcolor1: TMenuItem;
    borderleftstyle1: TMenuItem;
    borderrightstyle1: TMenuItem;
    bordertopstyle1: TMenuItem;
    borderbottomstyle1: TMenuItem;
    borderwidth1: TMenuItem;
    bottom1: TMenuItem;
    clear1: TMenuItem;
    clip1: TMenuItem;
    direction1: TMenuItem;
    float1: TMenuItem;
    color2: TMenuItem;
    content1: TMenuItem;
    Save1: TMenuItem;
    SaveDialog1: TSaveDialog;
    New1: TMenuItem;
    Author1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel6: TPanel;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel3: TPanel;
    StringGrid1: TStringGrid;
    Panel4: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    ListBox2: TListBox;
    Panel5: TPanel;
    TreeView1: TTreeView;
    Memo1: TMemo;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListBox1DblClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Append1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure AddTextToGrid(text: string);
    procedure PropClick(Sender: TObject);
    procedure StringGrid1GetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: String);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure ListBox2Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure LoadList(fname: string; append: boolean; sep: string);
    procedure SaveData(index: integer);
    procedure Save1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Author1Click(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  class_list: TStringList;
  cl_var_count: integer; //viimase vaadatud klassi muutujate arv.
  num_classes: integer; //klasside arv.
  num_lines: integer; //ridade arv sisendfailis.
  chars: set of char;
  nums: set of char;
  last_x, last_y: integer;
  program_folder: string;
  separator: string; //mitme väärtuse puhul väljal väärtuste eraldaja.
  not_saved: boolean; //näitab, kas stringgrid'is olevad andmed on salvestatud.
  last_opened: integer; //viimati avatud oleva klassi järjenumber
  Css: TCss;

implementation

uses AddClass, Copyright;

type
  TCaptionControl = class(TMenuItem)
  public
    property Caption;
end;

{$R *.dfm}

procedure TForm1.SaveData(index: integer); //stringgrid'is olevate andmete lisamine classide listi.
var i: integer;
  tmp: string;
begin
  tmp:=Panel5.Caption +'{';
  i:=1;
  while StringGrid1.Cells[0, i]<>'' do
  begin
    tmp:=tmp +StringGrid1.Cells[0, i] +': ' +StringGrid1.Cells[1, i] +';';
    inc(i);
  end;
  tmp:=tmp +'}';
  class_list.Strings[index]:=tmp;
  not_saved:=false;
end;

procedure TForm1.AddTextToGrid(text: string);
var y: integer;
begin
  y:=StringGrid1.Selection.TopLeft.Y;
  StringGrid1.Cells[0, y]:=text;
  StringGrid1.RowCount:=y+2;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  i: integer;
  treenode: TTreeNode;
  ClassList: TCssStrList;
  media: string;
begin
  StringGrid1.ColWidths[1]:=300;
  chars:=['a'..'z', '-', '.', ';', ':', ',', '#', ' ', '/', '*', '@', '_'];
  nums:=['0'..'9'];
  class_list:=TStringList.Create;
  Panel4.Visible:=false;
  program_folder:=ExtractFileDir(ParamStr(0));
  separator:=' ';
  StringGrid1.Enabled:=false;
  not_saved:=false;

  //Css.Statements.Free;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  class_list.Free;
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
var
  buffer, lbuffer :string;
  i: integer;
  ch: char;
  x, y: integer;
  color_combo: TObject;
  def_started: boolean; //parsimine on kaugemale jõudnud märgist {;
begin
  if not_saved then SaveData(last_opened);
  for i:=1 to cl_var_count do //Stringgrid'i puhastamine.
  begin
    StringGrid1.Cells[0, i]:='';
    StringGrid1.Cells[1, i]:='';
  end;
  cl_var_count:=0;
  //buffer:=class_list.Strings[ListBox1.ItemIndex];
  //last_opened:=ListBox1.ItemIndex;
  x:=0;//StringGrid jaoks vajalikud muutujad.
  y:=1;
  def_started:=false;
  for i:=1 to length(buffer) do
  begin
    ch:=buffer[i];
    lbuffer:=lbuffer +ch;
    if ch='{' then //klassi muutujate algus.
    begin
      def_started:=true;
      Panel5.Caption:=trim(copy(lbuffer, 1, length(lbuffer)-1));
      lbuffer:='';
    end;
    if (ch=':') and def_started then //muutuja on käes.
    begin
      lbuffer:=trim(copy(lbuffer, 1, length(lbuffer)-1));
      StringGrid1.Cells[x, y]:=lbuffer;
      lbuffer:='';
      x:=1;
    end;
    if (ch=';') or (ch='}') then //väärtus on käes.
    begin
      StringGrid1.Cells[x, y]:=trim(copy(lbuffer, 1, length(lbuffer)-1));
      lbuffer:='';
      x:=0;
      inc(cl_var_count);
      inc(y);
      StringGrid1.RowCount:=y;
    end;
  end;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  StringGrid1.ColWidths[1]:=StringGrid1.Width-160;
end;

procedure TForm1.Append1Click(Sender: TObject);
var
  fm: TextFile;
  ch: char;
  lbuffer: string;
  classname: string;
  cbuffer: string; //{} märkide vahel olev tekst.
  buffer: string;
begin
  if OpenDialog1.Execute then
  begin
    Form1.Caption:='Css Editor: ' +OpenDialog1.FileName;
    cl_var_count:=0;
    num_lines:=0;
    AssignFile(fm, OpenDialog1.FileName);
    Reset(fm);
    num_classes:=0;
    lbuffer:=' '; //buffer, kuhu salvestatakse töödeldava klassi sisu.
    cbuffer:=' ';
    while not(eof(fm)) do
    begin
      read(fm, ch);//failist loeatakse tähthaaval.
      if LowerCase(ch)[1] in chars then
      begin
        lbuffer:=lbuffer +ch;
        if cbuffer[1]='{' then cbuffer:=cbuffer +ch; //kui andmeid lisatakse klassi.
      end;
      if ch='/' then delete(lbuffer, pos('/*', lbuffer), length(lbuffer)-pos('/*', lbuffer)+1); //kommentaaride emaldamine.
      if ch='{' then //klassi nimi on teada.
      begin
        lbuffer:=lbuffer +'{';
        classname:=copy(lbuffer, 1, length(lbuffer)-1);//saab optimeerida!!
        if pos(';', classname)>0 then classname:=copy(classname, pos(';', classname)+1, length(classname)-pos(';', classname));
        cbuffer:='{';
      end;
      if ch='}' then //klassi lõpp
      begin
        if lbuffer[length(lbuffer)]<>';' then lbuffer:=lbuffer+';';
        cbuffer:=cbuffer+'}';
        //RichEdit1.Lines.Add(classname +cbuffer);
        //ListBox1.Items.Add(trim(classname));
        if pos('{', classname)>0 then //Parse error!!!!!
        begin
          ShowMessage('Parse error! Puuduv "}" real ' +IntToStr(num_lines) +' .');
        end;
        class_list.Add(classname +cbuffer);
        lbuffer:='';
        cbuffer:=' ';//NB! ei tohi tühi olla
        inc(num_classes);
      end;
      if ch in nums then
      begin
        lbuffer:=lbuffer +ch;
        if cbuffer[1]='{' then cbuffer:=cbuffer+ch;
      end;
      if ch=#13 then inc(num_lines);
    end;
    CloseFile(fm);
    StringGrid1.Enabled:=true;
    if num_classes>0 then //kui failis olid klassid, siis näidatakse neist esimest.
    begin
      //ListBox1.ItemIndex:=0;
      ListBox1DblClick(nil);
      not_saved:=false;
    end;
  end;
end;

procedure TForm1.Open1Click(Sender: TObject);
var
  i: integer;
  media: string;
  treenode: TTreeNode;
  ClassList: TCssStrList;
begin
  if not(OpenDialog1.Execute) then exit;

  TreeView1.Items.Clear;

  for i:=0 to StringGrid1.RowCount-1 do
  begin
    StringGrid1.Cells[0, i]:='';
    STringGrid1.Cells[1, i]:='';
  end;

  Css.LoadFromFile(OpenDialog1.FileName);
  for i:=0 to Css.Count-1 do
  begin
    media:=Css.GetMediaName(i);
    if media<>'general' then media:='@media ' +media;
    treenode:=TreeView1.Items.AddChild(nil, media);
    Css.GetMediaClasses(i, ClassList);
    while ClassList.Count>0 do TreeView1.Items.AddChild(treenode, ClassList.Take);
  end;
  for i:=0 to Css.Statements.Count-1 do Memo1.Lines.Add(Css.Statements.Take);

end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  Form2.ShowModal;
  if not(StringGrid1.Enabled) then StringGrid1.Enabled:=true;
  inc(num_classes);
end;

procedure TForm1.PropClick(Sender: TObject);
begin
  AddTextToGrid(TCaptionControl(Sender).Caption);
end;

procedure TForm1.StringGrid1GetEditText(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
var
  prope: string;
begin
  if ACol=0 then exit;
  ListBox2.Clear;
  prope:=LowerCase(StringGrid1.Cells[0, ARow]);
  if pos('color', prope)>0 then LoadList('color.vls', false, '');
  if pos('position', prope)>0 then LoadList('position.vls', false, '');
  if prope='background' then
  begin
    LoadList('color.vls', false, '');
    LoadList('position.vls', true, ' ');
  end;
  if prope='font-family' then LoadList('font.vls', false, ', ');
  if prope='font-size' then LoadList('size.vls', false, '');
  Panel4.Top:=StringGrid1.Selection.Top*15+25;
  Panel4.Left:=150;
  Panel4.Visible:=true;
  last_x:=ACol;
  last_y:=ARow;
  not_saved:=true;
end;

procedure TForm1.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if Panel4.Visible then Panel4.Visible:=false;
end;

procedure TForm1.ListBox2Click(Sender: TObject);
var tmp: string;
begin
  tmp:=StringGrid1.Cells[last_x, last_y];
  if tmp<>'' then tmp:=tmp +separator;
  if separator='' then tmp:='';
  tmp:=tmp +ListBox2.Items.Strings[ListBox2.ItemIndex];
  StringGrid1.Cells[last_x, last_y]:=tmp;
end;

procedure TForm1.Label2Click(Sender: TObject);
begin
  Panel4.Visible:=false;
end;

procedure TForm1.LoadList(fname: string; append: boolean; sep: string);
var fm: TextFile;
  rida: string;
begin
  if not(append) then ListBox2.Items.Clear;
  AssignFile(fm, program_folder +'/values/' +fname);
  Reset(fm);
  while not(eof(fm)) do
  begin
    Readln(fm, rida);
    ListBox2.Items.Add(rida);
  end;
  CloseFile(fm);
  separator:=sep;
end;

procedure TForm1.Save1Click(Sender: TObject);
var i, j: integer;
  fm: TextFile;
  rida: string;
begin
  if SaveDialog1.Execute then
  begin
    AssignFile(fm, SaveDialog1.Filename);
    Rewrite(fm);
    for i:=0 to num_classes-1 do
    begin
      rida:=class_list.Strings[i];
      for j:=1 to length(rida) do if rida[j]<>' ' then write(fm, rida[j]);
      writeln(fm);
    end;
    CloseFile(fm);
  end;
end;

procedure TForm1.New1Click(Sender: TObject); //Uues css faili alustamine.
var i:integer;
begin
  for i:=1 to StringGrid1.RowCount do
  begin
    StringGrid1.Cells[0, i]:='';
    StringGrid1.Cells[1, i]:='';
  end;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  //class_list.Delete(ListBox1.ItemIndex);
  //ListBox1.DeleteSelected;
  dec(num_classes);
end;

procedure TForm1.Author1Click(Sender: TObject);
begin
  Form3.ShowModal;
end;

procedure TForm1.TreeView1Click(Sender: TObject);
var
  nodelist: TCssValList;
  field: string;
  value: string;
  m, c: integer;
  i: integer;
begin
  if TreeView1.SelectionCount=0 then exit;
  if not(TreeView1.Selected.HasChildren) then
  begin
    Panel5.Caption:=TreeView1.Selected.Text;
    for i:=1 to StringGrid1.RowCount-1 do {StringGrid'i puhastamine vanadest andmetest}
    begin
      StringGrid1.Cells[0, i]:='';
      StringGrid1.Cells[1, i]:='';
    end;
    StringGrid1.RowCount:=2;
    c:=TreeView1.Selected.Index;
    m:=TreeView1.Selected.Parent.Index;
    Css.GetClassNodes(m, c, nodelist);
    for i:=0 to nodelist.Count-1 do
    begin
      nodelist.Take(field, value);
      StringGrid1.Cells[0, i]:=field;
      StringGrid1.Cells[1, i]:=value;
      StringGrid1.RowCount:=i+1;
    end;
  end;
end;

end.
