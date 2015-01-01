object Form3: TForm3
  Left = 185
  Top = 181
  BorderStyle = bsDialog
  Caption = 'Destination'
  ClientHeight = 88
  ClientWidth = 369
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 8
    Top = 24
    Width = 265
    Height = 21
    TabOrder = 0
    Text = '%path\'
  end
  object Button1: TButton
    Left = 8
    Top = 56
    Width = 65
    Height = 25
    Caption = 'Ok'
    TabOrder = 1
    OnClick = DestOk
  end
  object Button2: TButton
    Left = 88
    Top = 56
    Width = 65
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = CancDest
  end
end
