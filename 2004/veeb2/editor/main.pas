unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdFTP, Menus;

type

andmekirje=record
  nimi: string[10]; {muutuja nimi}
  vaartus: string[255]; {muutuja väärtus}
end;

objektityyp=(html, thtml, err, css); {err kasutatakse vea tähistamiseks,
näiteks kui objekti kirjeldust ei asu failis}

{objektide kirjeldused asuvad ühises failis}
objektikirje=record
  nimi: string[10]; {objekti nimi}
  tyyp: objektityyp; {tüübiks võib html või templeit}
end;

  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    Button3: TButton;
    Edit2: TEdit;
    Bevel1: TBevel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    GroupBox2: TGroupBox;
    ListBox1: TListBox;
    Button4: TButton;
    Button5: TButton;
    Bevel2: TBevel;
    Label4: TLabel;
    Label5: TLabel;
    Edit3: TEdit;
    Label6: TLabel;
    Edit4: TEdit;
    Label7: TLabel;
    MaskEdit1: TMaskEdit;
    IdFTP1: TIdFTP;
    Label8: TLabel;
    Label9: TLabel;
    Button6: TButton;
    Edit5: TEdit;
    Label10: TLabel;
    MainMenu1: TMainMenu;
    Fail1: TMenuItem;
    Ava1: TMenuItem;
    N1: TMenuItem;
    Vlju1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure IdFTP1Connected(Sender: TObject);
    procedure IdFTP1Disconnected(Sender: TObject);
    procedure IdFTP1Status(axSender: TObject; const axStatus: TIdStatus;
      const asStatusText: String);
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Vlju1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  objektid: file of objektikirje;
  opened: boolean;
  obj: objektikirje;
  workdir: string;

implementation
uses Objects, Code, Data, Lang;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  obj: objektikirje;
  i: word;
begin
  if OpenDialog1.Execute then
  begin
    Edit1.Text:=OpenDialog1.FileName;
    workdir:=ExtractFilePath(Edit1.Text);
    Form5.ListBox1.Items.LoadFromFile(workdir +'/keeled.txt');
    AssignFile(objektid, OpenDialog1.FileName);
    Reset(objektid);
    for i:=1 to FileSize(objektid) do
    begin
      Read(objektid, obj);
      ListBox1.Items.Add(obj.nimi);
    end;
    Label1.Caption:='Number of records: ' +IntToStr(FileSize(objektid));
    opened:=true;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if Edit1.Text<>'' then Form2.ShowModal;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  obj: objektikirje;

  procedure SorteeriObjektid;
  var
    i, j, koht: word;
    min, tmp, alg: objektikirje;
  begin
    for i:=0 to FileSize(objektid)-2 do
    begin
      Seek(objektid, i);
      Read(objektid, min);
      alg:=min;
      koht:=i;
      for j:=i+1 to FileSize(objektid)-1 do
      begin
        Read(objektid, tmp);
        if tmp.nimi<min.nimi then
        begin
          min:=tmp;
          koht:=j;
        end;
      end;
      Seek(objektid, koht);
      Write(objektid, alg);
      Seek(objektid, i);
      Write(objektid, min);
    end;
  end;{SorteeriObjektid}

begin
  if Edit1.Text<>'' then
  begin
    Seek(objektid, FileSize(objektid));
    obj.nimi:=Edit2.Text;
    case ComboBox1.ItemIndex of
    -1:exit;
     0:obj.tyyp:=html;
     1:obj.tyyp:=thtml;
     2:obj.tyyp:=css;
    end;
    Write(objektid, obj);
    Label1.Caption:='Number of records: ' +IntToStr(FileSize(objektid));

    {faili sorteerimine}
    SorteeriObjektid;

    {tühjade failide tekitamine}
    if obj.tyyp=css then Form3.SynEdit1.Lines.SaveToFile(workdir +'/css/' +obj.nimi +'.css');
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var fnimi: string;
begin
  if ListBox1.ItemIndex>=0 then
  begin
    Seek(objektid, ListBox1.ItemIndex);
    Read(objektid, obj);
    if obj.tyyp=html then
    begin
      Form5.ShowModal;
      fnimi:=workdir +'/html/' +ListBox1.Items.Strings[ListBox1.ItemIndex] +'.' +keel +'.html';
      Form3.SynEdit1.Highlighter:=Form3.SynHTMLSyn1;
    end
    else if obj.tyyp=thtml then fnimi:=workdir +'/thtml/' +ListBox1.Items.Strings[ListBox1.ItemIndex] +'.tpl'
    else if obj.tyyp=css then
    begin
      fnimi:=workdir +'/css/' +ListBox1.Items.Strings[ListBox1.ItemIndex] +'.css';
      Form3.SynEdit1.Highlighter:=Form3.SynCssSyn1;
    end;
    Form3.SynEdit1.Lines.LoadFromFile(fnimi);
    codefile:=fnimi;
    Form3.Show;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if opened then CloseFile(objektid);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  opened:=false;
end;

procedure TForm1.IdFTP1Connected(Sender: TObject);
begin
  Label9.Caption:='connected';
end;

procedure TForm1.IdFTP1Disconnected(Sender: TObject);
begin
  Label9.Caption:='disconnected';
end;

procedure TForm1.IdFTP1Status(axSender: TObject; const axStatus: TIdStatus;
  const asStatusText: String);
begin
  Label9.Caption:=asStatusText;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  i: word;
  fnimi: string;
  ufnimi: string;
begin
  if not(opened) then exit;
  IdFtp1.Host:=Edit3.Text;
  IdFtp1.User:=Edit4.Text;
  IdFtp1.Password:=MaskEdit1.Text;
  IdFtp1.Passive:=true;
  IdFtp1.Connect(true);
  IdFtp1.ChangeDir(Edit5.Text);
  Label9.Caption:='objektid.dat';
  IdFtp1.Put(workdir +'/objektid.dat', 'objektid.dat');
  Seek(objektid, 0);
  for i:=1 to FileSize(objektid) do
  begin
    Read(objektid, obj);
    case obj.tyyp of
      html: begin fnimi:=workdir +'/html/' +obj.nimi +'.html'; ufnimi:='html/' +obj.nimi +'.html'; end;
      thtml: begin fnimi:=workdir +'/thtml/' +obj.nimi +'.tpl'; ufnimi:='thtml/' +obj.nimi +'.tpl'; end;
    end;
    Label9.Caption:=ufnimi;
    IdFtp1.Put(fnimi, ufnimi);

    if obj.tyyp=thtml then {andmefaili ülessaatmine}
    begin
      fnimi:=workdir +'/data/' +obj.nimi +'.dat';
      ufnimi:='data/' +obj.nimi +'.dat';
      Label9.Caption:=ufnimi;
      IdFtp1.Put(fnimi, ufnimi);
    end;
  end;

  IdFtp1.Disconnect;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  andmed: file of andmekirje;
  data: andmekirje;
  i: word;
begin
  if ListBox1.ItemIndex>=0 then
  begin
    Form5.ShowModal;
    Seek(objektid, ListBox1.ItemIndex);
    Read(objektid, obj);
    if obj.tyyp<>thtml then
    begin
      ShowMessage('Ei ole templeiditud html fail!');
      exit;
    end;

    datafile:=workdir +'/data/' +obj.nimi +'.' +keel +'.dat';
    AssignFile(andmed, datafile);
    Reset(andmed);
    if FileSize(andmed)=0 then Form4.ValueListEditor1.InsertRow('new', 'new value', true)
    else
    for i:=0 to FileSize(andmed)-1 do
    begin
      Read(andmed, data);
      Form4.ValueListEditor1.InsertRow(data.nimi, data.vaartus, true);
    end;
    CloseFile(andmed);
    Form4.Show;
  end;
end;

procedure TForm1.Vlju1Click(Sender: TObject);
begin
  Form1.Close;
end;

end.
