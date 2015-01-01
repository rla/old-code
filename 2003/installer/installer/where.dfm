object Form3: TForm3
  Left = 183
  Top = 149
  Width = 320
  Height = 347
  Caption = 'WhereTo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = Close
  OnShow = ShowWhereTo
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 66
    Height = 13
    Caption = 'Pick Directory'
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 136
    Top = 40
    Width = 169
    Height = 209
    ItemHeight = 16
    TabOrder = 0
    OnChange = DirChange
  end
  object DriveComboBox1: TDriveComboBox
    Left = 136
    Top = 16
    Width = 169
    Height = 19
    TabOrder = 1
    OnChange = ChangeDrive
  end
  object Edit1: TEdit
    Left = 8
    Top = 256
    Width = 297
    Height = 21
    TabOrder = 2
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 240
    Top = 288
    Width = 65
    Height = 25
    Caption = 'Next'
    TabOrder = 3
    OnClick = WhereToOk
  end
  object Panel1: TPanel
    Left = 8
    Top = 56
    Width = 115
    Height = 115
    BevelOuter = bvLowered
    TabOrder = 4
    Visible = False
    object Image1: TImage
      Left = 1
      Top = 1
      Width = 113
      Height = 113
      Align = alClient
    end
  end
end
