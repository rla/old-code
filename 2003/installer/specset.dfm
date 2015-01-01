object SpecForm: TSpecForm
  Left = 238
  Top = 151
  BorderStyle = bsDialog
  Caption = 'Special settings'
  ClientHeight = 348
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = SpecClose
  OnShow = ShowSpec
  PixelsPerInch = 96
  TextHeight = 13
  object Group: TGroupBox
    Left = 16
    Top = 16
    Width = 489
    Height = 289
    Caption = 'Group'
    TabOrder = 0
    object cb1: TCheckBox
      Left = 16
      Top = 40
      Width = 201
      Height = 17
      Caption = 'cb1'
      TabOrder = 0
      Visible = False
    end
    object cb2: TCheckBox
      Left = 16
      Top = 80
      Width = 145
      Height = 25
      Caption = 'cb2'
      TabOrder = 1
      Visible = False
    end
    object cb3: TCheckBox
      Left = 16
      Top = 128
      Width = 121
      Height = 17
      Caption = 'cb3'
      TabOrder = 2
      Visible = False
    end
    object cb4: TCheckBox
      Left = 16
      Top = 176
      Width = 113
      Height = 17
      Caption = 'cb4'
      TabOrder = 3
      Visible = False
    end
  end
end
