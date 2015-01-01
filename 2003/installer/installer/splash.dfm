object Form2: TForm2
  Left = 272
  Top = 41
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Form2'
  ClientHeight = 173
  ClientWidth = 387
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 387
    Height = 173
    AutoSize = True
    IncrementalDisplay = True
    Proportional = True
  end
  object Timer1: TTimer
    Interval = 3000
    OnTimer = Form2Delay
    Left = 72
    Top = 24
  end
end
