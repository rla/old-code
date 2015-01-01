object Form1: TForm1
  Left = 103
  Top = 91
  BorderStyle = bsSingle
  Caption = 'Mp3Id3Tag fix'
  ClientHeight = 412
  ClientWidth = 672
  Color = cl3DLight
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = ShowingForm
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 412
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Panel3: TPanel
      Left = 0
      Top = 41
      Width = 320
      Height = 371
      Align = alClient
      BorderWidth = 4
      TabOrder = 0
      object DirectoryListBox1: TDirectoryListBox
        Left = 5
        Top = 5
        Width = 147
        Height = 361
        Align = alClient
        Ctl3D = True
        ItemHeight = 16
        ParentCtl3D = False
        TabOrder = 0
        OnChange = ChangeDir
      end
      object FileListBox1: TFileListBox
        Left = 152
        Top = 5
        Width = 163
        Height = 361
        Align = alRight
        Ctl3D = True
        ItemHeight = 13
        Mask = '*.mp3'
        ParentCtl3D = False
        TabOrder = 1
        OnDblClick = ListBoxMp3DblClick
      end
    end
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 320
      Height = 41
      Align = alTop
      TabOrder = 1
      object DriveComboBox1: TDriveComboBox
        Left = 8
        Top = 6
        Width = 169
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        OnChange = ChangeDrive
      end
    end
  end
  object Panel2: TPanel
    Left = 320
    Top = 0
    Width = 352
    Height = 412
    Align = alRight
    BorderWidth = 4
    Caption = 'Panel2'
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 5
      Top = 263
      Width = 342
      Height = 137
      Align = alTop
      Caption = 'Mp3 ID3 v1'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
      object StringGrid1: TStringGrid
        Left = 8
        Top = 16
        Width = 257
        Height = 89
        ColCount = 2
        Ctl3D = False
        DefaultRowHeight = 16
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
        ParentCtl3D = False
        ScrollBars = ssNone
        TabOrder = 0
      end
      object Button6: TButton
        Left = 24
        Top = 112
        Width = 97
        Height = 17
        Caption = 'Set'
        TabOrder = 1
        OnClick = Button6Click
      end
      object Button8: TButton
        Left = 296
        Top = 17
        Width = 25
        Height = 17
        Caption = 'FN'
        TabOrder = 2
        OnClick = Button8Click
      end
      object Button9: TButton
        Left = 272
        Top = 17
        Width = 17
        Height = 17
        Caption = 'C'
        TabOrder = 3
        OnClick = Button9Click
      end
      object Button10: TButton
        Left = 272
        Top = 34
        Width = 17
        Height = 17
        Caption = 'C'
        TabOrder = 4
        OnClick = Button10Click
      end
      object Button11: TButton
        Left = 272
        Top = 51
        Width = 17
        Height = 17
        Caption = 'C'
        TabOrder = 5
        OnClick = Button11Click
      end
      object Button12: TButton
        Left = 272
        Top = 68
        Width = 17
        Height = 17
        Caption = 'C'
        TabOrder = 6
        OnClick = Button12Click
      end
      object Button13: TButton
        Left = 272
        Top = 85
        Width = 17
        Height = 17
        Caption = 'C'
        TabOrder = 7
        OnClick = Button13Click
      end
      object Button14: TButton
        Left = 296
        Top = 34
        Width = 25
        Height = 17
        Caption = 'FN'
        TabOrder = 8
        OnClick = Button14Click
      end
    end
    object GroupBox2: TGroupBox
      Left = 5
      Top = 45
      Width = 342
      Height = 129
      Align = alTop
      Caption = 'Directory'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 1
      object Button1: TButton
        Left = 24
        Top = 24
        Width = 97
        Height = 17
        Caption = 'Set Artist'
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 24
        Top = 48
        Width = 97
        Height = 17
        Caption = 'Set Album'
        TabOrder = 1
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 24
        Top = 72
        Width = 97
        Height = 17
        Caption = 'Set Year'
        TabOrder = 2
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 24
        Top = 96
        Width = 97
        Height = 17
        Caption = 'Set Comment'
        TabOrder = 3
        OnClick = Button4Click
      end
      object Edit1: TEdit
        Left = 136
        Top = 24
        Width = 177
        Height = 21
        TabOrder = 4
        Text = 'new artist'
      end
      object Edit2: TEdit
        Left = 136
        Top = 48
        Width = 177
        Height = 21
        TabOrder = 5
        Text = 'new album'
      end
      object Edit3: TEdit
        Left = 136
        Top = 72
        Width = 177
        Height = 21
        TabOrder = 6
        Text = 'new year'
      end
      object Edit4: TEdit
        Left = 136
        Top = 96
        Width = 177
        Height = 21
        TabOrder = 7
        Text = 'new comment'
      end
    end
    object GroupBox3: TGroupBox
      Left = 5
      Top = 174
      Width = 342
      Height = 89
      Align = alTop
      Caption = 'Failname'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 2
      object Label1: TLabel
        Left = 8
        Top = 16
        Width = 34
        Height = 13
        Caption = 'Current'
      end
      object Label2: TLabel
        Left = 8
        Top = 40
        Width = 22
        Height = 13
        Caption = 'New'
      end
      object Edit5: TEdit
        Left = 48
        Top = 16
        Width = 265
        Height = 21
        ReadOnly = True
        TabOrder = 0
      end
      object Edit6: TEdit
        Left = 48
        Top = 40
        Width = 265
        Height = 21
        TabOrder = 1
      end
      object Button5: TButton
        Left = 24
        Top = 64
        Width = 97
        Height = 17
        Caption = 'Rename'
        Enabled = False
        TabOrder = 2
        OnClick = Button5Click
      end
      object Button7: TButton
        Left = 136
        Top = 64
        Width = 97
        Height = 17
        Caption = 'Delete'
        Enabled = False
        TabOrder = 3
        OnClick = Button7Click
      end
    end
    object Panel5: TPanel
      Left = 5
      Top = 5
      Width = 342
      Height = 40
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
      object Label5: TLabel
        Left = 16
        Top = 12
        Width = 42
        Height = 13
        Caption = 'Directory'
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 128
    Top = 48
    object File1: TMenuItem
      Caption = 'File'
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Author1: TMenuItem
      Caption = 'Version'
      OnClick = Author1Click
    end
  end
end
