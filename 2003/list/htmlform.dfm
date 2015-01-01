object Form2: TForm2
  Left = 198
  Top = 141
  BorderStyle = bsDialog
  Caption = 'Html settingud'
  ClientHeight = 318
  ClientWidth = 536
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = Form2Close
  OnCreate = HtmlCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 273
    Height = 281
    Caption = 'HTML dokument'
    TabOrder = 0
    object Memo1: TMemo
      Left = 8
      Top = 24
      Width = 257
      Height = 201
      Lines.Strings = (
        'Memo1')
      TabOrder = 0
    end
    object StaticText1: TStaticText
      Left = 8
      Top = 240
      Width = 174
      Height = 17
      Caption = '%nimekiri peab paiknema eraldi real.'
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 288
    Top = 8
    Width = 241
    Height = 281
    Caption = 'Kaust'
    TabOrder = 1
    object HtmlDirTree: TDirectoryListBox
      Left = 8
      Top = 24
      Width = 225
      Height = 201
      ItemHeight = 16
      TabOrder = 0
      OnChange = HtmlDirChange
    end
    object HtmlPath: TLabeledEdit
      Left = 8
      Top = 248
      Width = 225
      Height = 21
      EditLabel.Width = 43
      EditLabel.Height = 13
      EditLabel.Caption = 'HtmlPath'
      LabelPosition = lpAbove
      LabelSpacing = 3
      TabOrder = 1
    end
  end
  object HtmlOkBtn: TButton
    Left = 56
    Top = 296
    Width = 129
    Height = 17
    Caption = 'OK'
    TabOrder = 2
    OnClick = HtmlOkClick
  end
  object HtmlCloseBtn: TButton
    Left = 216
    Top = 296
    Width = 129
    Height = 17
    Caption = 'T'#252'hista'
    TabOrder = 3
    OnClick = HtmlCloseClick
  end
end
