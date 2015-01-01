object Form6: TForm6
  Left = 251
  Top = 168
  Width = 469
  Height = 207
  Caption = 'Install Proccess'
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
  object Label1: TLabel
    Left = 24
    Top = 56
    Width = 59
    Height = 13
    Caption = 'Progress bar'
  end
  object ProgressBar1: TProgressBar
    Left = 24
    Top = 72
    Width = 401
    Height = 17
    Min = 0
    Max = 100
    TabOrder = 0
  end
end
