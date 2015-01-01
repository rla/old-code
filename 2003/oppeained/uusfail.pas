unit UusFail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, ComCtrls, Menus, Buttons;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    RichEdit1: TRichEdit;
    PopupMenu1: TPopupMenu;
    Kopeeri1: TMenuItem;
    Kleebi1: TMenuItem;
    N1: TMenuItem;
    Paks1: TMenuItem;
    Allajoonitud1: TMenuItem;
    SpeedButton1: TSpeedButton;
    N2: TMenuItem;
    Font1: TMenuItem;
    FontDialog1: TFontDialog;
    SpeedButton2: TSpeedButton;
    avaline1: TMenuItem;
    procedure ShowForm(Sender: TObject);
    procedure ShortKey(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Paks1Click(Sender: TObject);
    procedure Allajoonitud1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Font1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure avaline1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  Faili_nimi: string;

implementation

uses
  MainForm, Html, rtf2html, HTMLEncode;

{$R *.dfm}

procedure TForm3.ShowForm(Sender: TObject);
begin
  Edit1.Text:=Form1.TreeView1.Selected.Text +' - ';
end;

procedure TForm3.ShortKey(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //if ssCtrl in Shift then
  //begin

  //end;
end;

procedure TForm3.Paks1Click(Sender: TObject);
begin
  RichEdit1.SelAttributes.Style:=[fsBold];
end;

procedure TForm3.Allajoonitud1Click(Sender: TObject);
begin
  RichEdit1.SelAttributes.Style:=[fsUnderline];
end;

procedure TForm3.SpeedButton1Click(Sender: TObject);
var
  sisu: String;
  algus: String;
  keskosa: String;
  lopp: String;
  fm:TextFile;
begin
  algus:='<html><head><title>';
  keskosa:='</title><link rel="stylesheet" href="stiil.css" type="text/css"></head><body><p class="pealkiri">';
  lopp:='</body></html>';
  sisu:=HTMLEncode.HTMLEncodeRichEdit(RichEdit1);
  sisu:=algus +Edit1.Text +keskosa +Edit1.Text +'</p><hr><br>' +sisu +lopp;
  AssignFile(fm, Faili_nimi);
  Rewrite(fm);
  Write(fm, sisu);
  CloseFile(fm);
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
  showmessage(HTMLEncode.HTMLEncodeRichEdit(RichEdit1));
end;

procedure TForm3.Font1Click(Sender: TObject);
begin
  if FontDialog1.Execute then RichEdit1.Font:=FontDialog1.Font;
end;

procedure TForm3.SpeedButton2Click(Sender: TObject);
begin
  if RichEdit1.Modified then ShowMessage('Salvestamata')
    else Form3.Close;
end;

procedure TForm3.avaline1Click(Sender: TObject);
begin
  RichEdit1.SelAttributes.Style:=[];
end;

end.
