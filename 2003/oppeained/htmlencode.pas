(*
** Name: HTMLEncode
** Desc: HTML encoding functions. Contains a RTF to HTML converter.
**
** Copyright (C) 2003 Derek J. Evans. All Rights Reserved.
*)

unit HTMLEncode;

interface

uses Windows, Classes, ComCtrls, SysUtils, Graphics, RichEdit, StrUtils;

function HTMLEncodeHTML(const AHead, ABody: String): String;
function HTMLEncodeHead(const ATitle: String): String;
function HTMLEncodeBody(const ABGColor: TColor; const AInnerHTML: String): String;
function HTMLEncodeRichEdit(const ARichEdit: TRichEdit): String;
procedure RichEditCopy(const ADst, ASrc: TRichEdit);

implementation

(*
** Name: HTMLEncodeValue
** Desc: Encodes a HTML tag attribute.
*)
function HTMLEncodeValue(const AValue: String): String;
begin
  Result := '"' + AValue + '"';
end;

(*
** Name: HTMLEncodeColor
** Desc: Encodes a HTML color value.
*)
function HTMLEncodeColor(const AColor: TColor): String;
begin
  Result :=
    IntToHex(GetRValue(AColor), 2) +
    IntToHex(GetGValue(AColor), 2) +
    IntToHex(GetBValue(AColor), 2) ;
end;

function HTMLEncodeText(const AText: String): String;
begin
  Result := AText;
  
  Result := AnsiReplaceText(Result, '&', '&amp;' );
  Result := AnsiReplaceText(Result, '<', '&lt;'  );
  Result := AnsiReplaceText(Result, '>', '&gt;'  );
  Result := AnsiReplaceText(Result, '"', '&quot;');
  Result := AnsiReplaceText(Result, #9 , '        ');

  while AnsiContainsStr(Result, '  ') do
  begin
    Result := AnsiReplaceText(Result, '  ' , '&nbsp; ');
  end;

  Result := AnsiReplaceText(AdjustLineBreaks(Result), #13#10, '<BR>');
end;

function HTMLEncodeHTML(const AHead, ABody: String): String;
begin
  Result := Format('<HTML>%s%s</HTML>', [AHead, ABody]);
end;

function HTMLEncodeHead(const ATitle: String): String;
begin
  Result := Format('<HEAD><TITLE>%s</TITLE></HEAD>', [ATitle]);
end;

function HTMLEncodeBody(const ABGColor: TColor; const AInnerHTML: String): String;
begin
  Result := Format('<BODY bgColor=%s>%s</BODY>', [HTMLEncodeColor(ABGColor), AInnerHTML]);
end;

function HTMLEncodeFontStyles(const AFontStyles: TFontStyles; const AInnerHTML: String): String;
begin
  Result := '';
  
  if fsBold      in AFontStyles then Result := Result + '<B>';
  if fsItalic    in AFontStyles then Result := Result + '<I>';
  if fsUnderline in AFontStyles then Result := Result + '<U>';
  if fsStrikeOut in AFontStyles then Result := Result + '<S>';

  Result := Result + AInnerHTML;
  
  if fsStrikeOut in AFontStyles then Result := Result + '</S>';
  if fsUnderline in AFontStyles then Result := Result + '</U>';
  if fsItalic    in AFontStyles then Result := Result + '</I>';
  if fsBold      in AFontStyles then Result := Result + '</B>';
end;

function HTMLEncodeFont(const AFont: TFont; const AInnerHTML: String): String;
begin
  if Length(AInnerHTML) > 0 then
  begin
    Result := Format('<FONT color=%s face=%s STYLE=text-decoration:none;font-size:%dpt>%s</FONT>', [
      HTMLEncodeColor(AFont.Color), HTMLEncodeValue(AFont.Name), AFont.Size,
      HTMLEncodeFontStyles(AFont.Style, AInnerHTML)]);
  end
  else
  begin
    Result := '';
  end;
end;

function HTMLEncodeTextAttributes(const ATextAttributes: TTextAttributes; const AInnerHTML: String): String;
var LFont: TFont;
begin
  LFont := TFont.Create;
  try
    LFont.Assign(ATextAttributes);
    Result := HTMLEncodeFont(LFont, AInnerHTML);
  finally
    FreeAndNil(LFont);
  end;
end;

function HTMLEncodeAlignment(const AAlignment: TAlignment): String;
begin
  case AAlignment of
    taLeftJustify : Result := 'left';
    taRightJustify: Result := 'right';
    taCenter      : Result := 'center';
  end;
end;

function HTMLEncodeParaAttributes(const AParaAttributes: TParaAttributes; const AInnerHTML: String): String;
begin
  if Length(AInnerHTML) > 0 then
  begin
    Result := Format('<P align=%s style=margin-left:%dpt;margin-right:%dpt;text-indent:%dpt;margin-top:0.01pt;margin-bottom:0.01pt;>%s</P>', [
      HTMLEncodeAlignment(AParaAttributes.Alignment),
      AParaAttributes.FirstIndent,
      AParaAttributes.RightIndent,
      AParaAttributes.FirstIndent,
      AInnerHTML]);
      
    if AParaAttributes.Numbering = nsBullet then
    begin
      Result := '<LI>' + Result + '</LI>';
    end;    
  end
  else
  begin
    Result := '';  
  end;
end;

procedure RichEditSelectChar(const ARichEdit: TRichEdit; const ASelStart: Integer);
begin
  ARichEdit.SelStart := ASelStart;
  ARichEdit.SelLength := 1;
  if ARichEdit.SelLength = 0 then ARichEdit.SelLength := 2;
end;

function HTMLEncodeRichEdit(const ARichEdit: TRichEdit): String;
var
  Name, Paragraph: String;
  I, J, Size, TextLength, LeftIndent, RightIndent, FirstIndent: Integer;
  Alignment: TAlignment;
  IsEndOfParagraph: Boolean;
  Color: TColor;
  Style: TFontStyles;
  Numbering: TNumberingStyle;
begin
  LeftIndent  := 0;
  RightIndent := 0;
  FirstIndent := 0;
  Alignment   := taLeftJustify;
  Numbering   := nsNone;
  
  ARichEdit.Lines.BeginUpdate;
  try
    TextLength := Length(ARichEdit.Lines.Text);
    IsEndOfParagraph := True;

    I := 0;
    while I < TextLength do
    begin
      RichEditSelectChar(ARichEdit, I);

      Size  := ARichEdit.SelAttributes.Size;
      Color := ARichEdit.SelAttributes.Color;
      Name  := ARichEdit.SelAttributes.Name;
      Style := ARichEdit.SelAttributes.Style;

      if IsEndOfParagraph then
      begin
        LeftIndent  := ARichEdit.Paragraph.LeftIndent;
        RightIndent := ARichEdit.Paragraph.RightIndent;
        FirstIndent := ARichEdit.Paragraph.FirstIndent;
        Alignment   := ARichEdit.Paragraph.Alignment;
        Numbering   := ARichEdit.Paragraph.Numbering;
      end;
      IsEndOfParagraph := True;

      J := I;
      while J < TextLength do
      begin
        RichEditSelectChar(ARichEdit, J);

        if LeftIndent  <> ARichEdit.Paragraph.LeftIndent  then Break;
        if RightIndent <> ARichEdit.Paragraph.RightIndent then Break;
        if FirstIndent <> ARichEdit.Paragraph.FirstIndent then Break;
        if Alignment   <> ARichEdit.Paragraph.Alignment   then Break;
        if Numbering   <> ARichEdit.Paragraph.Numbering   then Break;

        if Size        <> ARichEdit.SelAttributes.Size   then begin IsEndOfParagraph := False; Break; end;
        if Color       <> ARichEdit.SelAttributes.Color  then begin IsEndOfParagraph := False; Break; end;
        if Name        <> ARichEdit.SelAttributes.Name   then begin IsEndOfParagraph := False; Break; end;
        if Style       <> ARichEdit.SelAttributes.Style  then begin IsEndOfParagraph := False; Break; end;

        Inc(J, ARichEdit.SelLength);
        if ARichEdit.SelLength = 2 then Break;        
      end;

      ARichEdit.SelStart  := I;
      ARichEdit.SelLength := J - I;

      Paragraph := Paragraph + HTMLEncodeTextAttributes(ARichEdit.SelAttributes, HTMLEncodeText(ARichEdit.SelText));

      if IsEndOfParagraph then
      begin
        Result := Result + HTMLEncodeParaAttributes(ARichEdit.Paragraph, Paragraph);
        Paragraph := '';
      end;
      Inc(I, J - I);
    end;
  finally
    ARichEdit.Lines.EndUpdate();
  end;
end;

procedure RichEditCopy(const ADst, ASrc: TRichEdit);
var LMemoryStream: TMemoryStream;
begin
  LMemoryStream := TMemoryStream.Create;
  try
    ASrc.Lines.SaveToStream(LMemoryStream);
    LMemoryStream.Position := 0;
    ADst.Lines.LoadFromStream(LMemoryStream);
  finally
    FreeAndNil(LMemoryStream);
  end;
end;

end.
