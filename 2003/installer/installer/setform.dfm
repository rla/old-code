object Form4: TForm4
  Left = 222
  Top = 113
  Width = 542
  Height = 375
  Caption = 'Settings'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = CloseFrm
  OnShow = Start
  PixelsPerInch = 96
  TextHeight = 13
  object CheckListBox1: TCheckListBox
    Left = 8
    Top = 8
    Width = 521
    Height = 225
    ItemHeight = 13
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 8
    Top = 240
    Width = 521
    Height = 57
    TabOrder = 1
  end
  object Button1: TButton
    Left = 16
    Top = 312
    Width = 65
    Height = 25
    Caption = 'Back'
    TabOrder = 2
    OnClick = GoBack
  end
  object Button2: TButton
    Left = 96
    Top = 312
    Width = 65
    Height = 25
    Caption = 'Forward'
    TabOrder = 3
    OnClick = SettingsOk
  end
end
