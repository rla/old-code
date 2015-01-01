object Form4: TForm4
  Left = 168
  Top = 147
  Width = 544
  Height = 375
  BorderStyle = bsSizeToolWin
  Caption = 'Data editor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 312
    Width = 536
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Button1: TButton
      Left = 8
      Top = 8
      Width = 73
      Height = 25
      Caption = 'Save'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 88
      Top = 8
      Width = 73
      Height = 25
      Caption = 'Close'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object ValueListEditor1: TValueListEditor
    Left = 0
    Top = 0
    Width = 536
    Height = 312
    Align = alClient
    DefaultRowHeight = 15
    KeyOptions = [keyEdit, keyAdd, keyDelete]
    PopupMenu = PopupMenu1
    TabOrder = 1
    TitleCaptions.Strings = (
      'Variable name'
      'Value')
    ColWidths = (
      150
      380)
  end
  object PopupMenu1: TPopupMenu
    Left = 168
    Top = 88
    object Insertnew1: TMenuItem
      Caption = 'Insert new'
      OnClick = Insertnew1Click
    end
  end
end
