object Form5: TForm5
  Left = 307
  Top = 151
  Width = 500
  Height = 249
  Caption = 'Special Settings'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = CloseFrm
  OnShow = GetSettings
  PixelsPerInch = 96
  TextHeight = 13
  object CheckBox1: TCheckBox
    Left = 24
    Top = 32
    Width = 449
    Height = 25
    Caption = 'CheckBox1'
    TabOrder = 0
    Visible = False
  end
  object CheckBox2: TCheckBox
    Left = 24
    Top = 80
    Width = 449
    Height = 25
    Caption = 'CheckBox2'
    TabOrder = 1
    Visible = False
  end
  object CheckBox3: TCheckBox
    Left = 24
    Top = 128
    Width = 449
    Height = 33
    Caption = 'CheckBox3'
    TabOrder = 2
    Visible = False
  end
  object Button1: TButton
    Left = 24
    Top = 184
    Width = 65
    Height = 25
    Caption = 'Back'
    TabOrder = 3
    OnClick = Back
  end
  object Button2: TButton
    Left = 104
    Top = 184
    Width = 65
    Height = 25
    Caption = 'Finish'
    TabOrder = 4
    OnClick = DoInstalling
  end
end
