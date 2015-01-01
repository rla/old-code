object Form7: TForm7
  Left = 275
  Top = 204
  Width = 372
  Height = 110
  Caption = 'Setting Up Registry'
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
  object Label1: TLabel
    Left = 32
    Top = 32
    Width = 179
    Height = 13
    Caption = 'Please wait until setting up the registry'
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = CloseFrm
    Left = 248
    Top = 32
  end
end
