object Form1: TForm1
  Left = 203
  Top = 148
  BorderStyle = bsDialog
  Caption = 'Jc Installer'
  ClientHeight = 359
  ClientWidth = 470
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = Start
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 80
    Width = 470
    Height = 209
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Button1: TButton
    Left = 8
    Top = 312
    Width = 65
    Height = 25
    Caption = 'Agree'
    TabOrder = 1
    OnClick = Agree
  end
  object Button2: TButton
    Left = 88
    Top = 312
    Width = 65
    Height = 25
    Caption = 'Disagree'
    TabOrder = 2
    OnClick = Disagree
  end
  object Panel1: TPanel
    Left = 0
    Top = 8
    Width = 470
    Height = 62
    BevelOuter = bvLowered
    TabOrder = 3
    object Image1: TImage
      Left = 1
      Top = 1
      Width = 468
      Height = 60
      Align = alClient
      Stretch = True
    end
  end
  object STCabReader1: TSTCabReader
    Left = 40
    Top = 248
  end
end
