object Form4: TForm4
  Left = 157
  Top = 159
  Width = 324
  Height = 129
  Caption = 'Add Files To Default List'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 22
    Height = 13
    Caption = 'Path'
  end
  object Button1: TButton
    Left = 8
    Top = 64
    Width = 65
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = OkDefault
  end
  object Button2: TButton
    Left = 88
    Top = 64
    Width = 65
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = CancelDefault
  end
  object Edit1: TEdit
    Left = 8
    Top = 32
    Width = 297
    Height = 21
    TabOrder = 2
  end
end
