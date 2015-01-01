object CopyForm: TCopyForm
  Left = 142
  Top = 53
  Width = 443
  Height = 451
  Caption = 'JC Software Installer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = ShowMemo
  PixelsPerInch = 96
  TextHeight = 13
  object CopyMemo: TMemo
    Left = 0
    Top = 0
    Width = 435
    Height = 385
    Align = alTop
    TabOrder = 0
  end
  object Button1: TButton
    Left = 8
    Top = 392
    Width = 97
    Height = 25
    Caption = 'Agree'
    TabOrder = 1
    OnClick = OkClk
  end
  object Button2: TButton
    Left = 120
    Top = 392
    Width = 97
    Height = 25
    Caption = 'Disagree'
    TabOrder = 2
    OnClick = Valju
  end
end
