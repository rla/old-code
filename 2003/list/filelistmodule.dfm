object Form1: TForm1
  Left = 111
  Top = 223
  BorderStyle = bsDialog
  Caption = 'FileList'
  ClientHeight = 310
  ClientWidth = 535
  Color = clActiveBorder
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object KaustaPuu: TShellTreeView
    Left = 0
    Top = 0
    Width = 225
    Height = 310
    ObjectTypes = [otFolders]
    Root = 'rfDesktop'
    UseShellImages = True
    Align = alLeft
    AutoRefresh = False
    Ctl3d = True
    Indent = 19
    ParentColor = False
    ParentCtl3d = False
    RightClickSelect = True
    ShowRoot = False
    TabOrder = 0
    OnChange = JuurMuutus
  end
  object Laiendid: TGroupBox
    Left = 232
    Top = 8
    Width = 297
    Height = 49
    Caption = 'Faililaiendid'
    Color = clActiveBorder
    ParentColor = False
    TabOrder = 1
    object mp3chk: TCheckBox
      Left = 16
      Top = 16
      Width = 41
      Height = 17
      Caption = '.mp3'
      Color = clActiveBorder
      Ctl3D = False
      ParentColor = False
      ParentCtl3D = False
      TabOrder = 0
    end
    object avichk: TCheckBox
      Left = 144
      Top = 16
      Width = 41
      Height = 17
      Caption = '.avi'
      TabOrder = 1
    end
    object oggchk: TCheckBox
      Left = 80
      Top = 16
      Width = 41
      Height = 17
      Caption = '.ogg'
      TabOrder = 2
    end
    object wadchk: TCheckBox
      Left = 200
      Top = 16
      Width = 49
      Height = 17
      Caption = '.wad'
      TabOrder = 3
    end
  end
  object GroupBox2: TGroupBox
    Left = 232
    Top = 184
    Width = 297
    Height = 49
    Caption = 'Juur'
    TabOrder = 2
    object JuurEdit: TEdit
      Left = 8
      Top = 16
      Width = 281
      Height = 21
      TabOrder = 0
    end
  end
  object StatusGroup: TGroupBox
    Left = 232
    Top = 240
    Width = 297
    Height = 41
    Caption = 'Status'
    TabOrder = 3
    object Status: TLabel
      Left = 8
      Top = 16
      Width = 97
      Height = 13
      Caption = 'FileList by JC 2003...'
    end
  end
  object List: TGroupBox
    Left = 232
    Top = 64
    Width = 297
    Height = 113
    Caption = 'List'
    Color = clActiveBorder
    ParentColor = False
    TabOrder = 4
    object listtxtchk: TCheckBox
      Left = 16
      Top = 48
      Width = 57
      Height = 17
      Caption = 'List .txt'
      TabOrder = 0
      OnClick = ListChkClick
    end
    object txtpath: TEdit
      Left = 80
      Top = 48
      Width = 161
      Height = 21
      Color = clSilver
      Enabled = False
      TabOrder = 1
    end
    object Otsitxt: TButton
      Left = 248
      Top = 48
      Width = 41
      Height = 17
      Caption = 'Otsi'
      TabOrder = 2
      OnClick = OtsiTxtClick
    end
    object KaustagaChk: TCheckBox
      Left = 16
      Top = 24
      Width = 65
      Height = 17
      Caption = 'Kaustaga'
      Checked = True
      Ctl3D = True
      ParentCtl3D = False
      State = cbChecked
      TabOrder = 3
    end
    object ParandaChk: TCheckBox
      Left = 88
      Top = 24
      Width = 65
      Height = 17
      Caption = 'Paranda'
      TabOrder = 4
    end
    object HtmlBtn: TButton
      Left = 248
      Top = 80
      Width = 41
      Height = 17
      Caption = 'HTML'
      TabOrder = 5
      OnClick = HtmlClick
    end
    object HtmlPathEdit: TEdit
      Left = 80
      Top = 80
      Width = 161
      Height = 21
      Color = clSilver
      Enabled = False
      TabOrder = 6
    end
    object htmlchk: TCheckBox
      Left = 16
      Top = 80
      Width = 57
      Height = 17
      Caption = 'HTML'
      TabOrder = 7
      OnClick = HtmlChkClick
    end
  end
  object StartBtn: TButton
    Left = 240
    Top = 288
    Width = 129
    Height = 17
    Caption = 'Start'
    TabOrder = 5
    OnClick = startClick
  end
  object ExitBtn: TButton
    Left = 392
    Top = 288
    Width = 129
    Height = 17
    Caption = 'V'#228'lju'
    TabOrder = 6
    OnClick = valju
  end
  object OpenTxt: TOpenDialog
    Ctl3D = False
    Left = 64
    Top = 176
  end
end
