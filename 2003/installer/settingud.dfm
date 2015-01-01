object SetForm: TSetForm
  Left = 172
  Top = 160
  BorderStyle = bsDialog
  Caption = 'Installing Settings'
  ClientHeight = 348
  ClientWidth = 536
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = CloseSet
  OnShow = StartSet
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 72
    Height = 13
    Caption = 'What you want'
  end
  object SetList: TCheckListBox
    Left = 16
    Top = 40
    Width = 505
    Height = 185
    ItemHeight = 13
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 16
    Top = 240
    Width = 505
    Height = 57
    Color = clScrollBar
    ReadOnly = True
    TabOrder = 1
  end
  object Button1: TButton
    Left = 16
    Top = 312
    Width = 97
    Height = 25
    Caption = '<- Back'
    TabOrder = 2
    OnClick = TagasiClk
  end
  object Button2: TButton
    Left = 128
    Top = 312
    Width = 97
    Height = 25
    Caption = 'Next ->'
    TabOrder = 3
    OnClick = SetOk
  end
end
