object Form2: TForm2
  Left = -14
  Top = 169
  Width = 800
  Height = 337
  Caption = 'Files List'
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
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 313
    Height = 265
    Caption = 'Source'
    TabOrder = 0
    object DirectoryListBox1: TDirectoryListBox
      Left = 8
      Top = 16
      Width = 145
      Height = 241
      ItemHeight = 16
      TabOrder = 0
      OnChange = ChangeSDir
    end
    object FileListBox1: TFileListBox
      Left = 152
      Top = 16
      Width = 153
      Height = 241
      ExtendedSelect = False
      ItemHeight = 13
      TabOrder = 1
    end
  end
  object Button1: TButton
    Left = 328
    Top = 80
    Width = 65
    Height = 25
    Caption = 'Add'
    TabOrder = 1
    OnClick = LisaFailid
  end
  object GroupBox2: TGroupBox
    Left = 400
    Top = 8
    Width = 385
    Height = 265
    Caption = 'Files To Install'
    TabOrder = 2
    object ListBox1: TListBox
      Left = 8
      Top = 16
      Width = 369
      Height = 241
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object Button2: TButton
    Left = 8
    Top = 280
    Width = 65
    Height = 25
    Caption = 'Ok'
    TabOrder = 3
    OnClick = FilesListOk
  end
  object Button3: TButton
    Left = 88
    Top = 280
    Width = 65
    Height = 25
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = FilesListCanc
  end
  object Button4: TButton
    Left = 328
    Top = 120
    Width = 65
    Height = 25
    Caption = 'Remove'
    TabOrder = 5
    OnClick = RemoveList
  end
end
