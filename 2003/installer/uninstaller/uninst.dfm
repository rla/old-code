object Form1: TForm1
  Left = 97
  Top = 183
  Width = 641
  Height = 237
  Caption = 'JC Software Uninstaller'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = Start
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 633
    Height = 210
    Align = alClient
    TabOrder = 0
  end
  object Timer1: TTimer
    OnTimer = CloseFrm
    Left = 192
    Top = 16
  end
end
