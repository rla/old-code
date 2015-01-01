object Form1: TForm1
  Left = 33
  Top = 100
  Width = 728
  Height = 535
  Caption = 'Jc Installer Maker'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 208
    Top = 16
    Width = 505
    Height = 449
    ActivePage = TabSheet3
    TabIndex = 0
    TabOrder = 0
    object TabSheet3: TTabSheet
      Caption = 'Project'
      ImageIndex = 2
      object GroupBox2: TGroupBox
        Left = 0
        Top = 16
        Width = 497
        Height = 185
        Caption = 'Project'
        TabOrder = 0
        object Label5: TLabel
          Left = 8
          Top = 24
          Width = 28
          Height = 13
          Caption = 'Name'
        end
        object Label6: TLabel
          Left = 8
          Top = 112
          Width = 101
          Height = 13
          Caption = 'Bitmap ( .bmp ) Name'
        end
        object Edit4: TEdit
          Left = 8
          Top = 40
          Width = 265
          Height = 21
          TabOrder = 0
          Text = 'New Project'
        end
        object CheckBox1: TCheckBox
          Left = 8
          Top = 88
          Width = 169
          Height = 17
          Caption = 'Display Splash Screen At Start'
          TabOrder = 1
          OnClick = SplashClick
        end
        object Edit5: TEdit
          Left = 8
          Top = 128
          Width = 265
          Height = 21
          Enabled = False
          TabOrder = 2
        end
        object Button1: TButton
          Left = 288
          Top = 128
          Width = 65
          Height = 25
          Caption = 'Browse'
          TabOrder = 3
          OnClick = OtsiPilt
        end
      end
      object GroupBox3: TGroupBox
        Left = 0
        Top = 216
        Width = 497
        Height = 177
        Caption = 'Where To Create New Project'
        TabOrder = 1
        object Label7: TLabel
          Left = 280
          Top = 128
          Width = 87
          Height = 13
          Caption = 'Selected Directory'
        end
        object Label8: TLabel
          Left = 280
          Top = 24
          Width = 67
          Height = 13
          Caption = 'New Directory'
        end
        object ShellTreeView1: TShellTreeView
          Left = 8
          Top = 24
          Width = 265
          Height = 145
          ObjectTypes = [otFolders]
          Root = 'rfMyComputer'
          UseShellImages = True
          AutoRefresh = False
          Indent = 19
          ParentColor = False
          RightClickSelect = True
          ShowRoot = False
          TabOrder = 0
          OnChange = ChangeProDir
        end
        object Edit6: TEdit
          Left = 280
          Top = 144
          Width = 209
          Height = 21
          TabOrder = 1
          Text = 'C:\New Project'
        end
        object Edit7: TEdit
          Left = 280
          Top = 40
          Width = 209
          Height = 21
          TabOrder = 2
          Text = 'New Project'
        end
        object Button2: TButton
          Left = 280
          Top = 72
          Width = 65
          Height = 25
          Caption = 'Create New'
          TabOrder = 3
          OnClick = CreateNewDir
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Copyright'
      object Label2: TLabel
        Left = 8
        Top = 344
        Width = 86
        Height = 13
        Caption = 'Agree Button Text'
      end
      object Label1: TLabel
        Left = 8
        Top = 56
        Width = 73
        Height = 13
        Caption = 'Copyright notes'
      end
      object Label3: TLabel
        Left = 168
        Top = 344
        Width = 100
        Height = 13
        Caption = 'Disagree Button Test'
      end
      object Label4: TLabel
        Left = 8
        Top = 8
        Width = 93
        Height = 13
        Caption = 'Copyrigth Form Title'
      end
      object Memo1: TMemo
        Left = 8
        Top = 72
        Width = 481
        Height = 265
        TabOrder = 0
      end
      object Edit2: TEdit
        Left = 8
        Top = 360
        Width = 137
        Height = 21
        TabOrder = 1
        Text = 'Agree'
      end
      object Edit1: TEdit
        Left = 168
        Top = 360
        Width = 137
        Height = 21
        TabOrder = 2
        Text = 'Disagree'
      end
      object Edit3: TEdit
        Left = 8
        Top = 24
        Width = 265
        Height = 21
        TabOrder = 3
        Text = 'Copyright'
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'WhereTo'
      ImageIndex = 3
      object Label9: TLabel
        Left = 8
        Top = 88
        Width = 79
        Height = 13
        Caption = 'Default Directory'
      end
      object Label10: TLabel
        Left = 8
        Top = 144
        Width = 65
        Height = 13
        Caption = 'Label Caption'
      end
      object Label13: TLabel
        Left = 8
        Top = 32
        Width = 94
        Height = 13
        Caption = 'WhereTo Form Title'
      end
      object Edit8: TEdit
        Left = 8
        Top = 104
        Width = 265
        Height = 21
        TabOrder = 0
        Text = 'C:\Program Files\New Project'
      end
      object Edit9: TEdit
        Left = 8
        Top = 160
        Width = 265
        Height = 21
        TabOrder = 1
        Text = 'Needed 1Mb'
      end
      object Edit12: TEdit
        Left = 8
        Top = 48
        Width = 265
        Height = 21
        TabOrder = 2
        Text = 'Where do you want to install?'
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Settings'
      ImageIndex = 1
      object Label11: TLabel
        Left = 8
        Top = 104
        Width = 86
        Height = 13
        Caption = 'Installation Setting'
      end
      object Label12: TLabel
        Left = 8
        Top = 48
        Width = 87
        Height = 13
        Caption = 'Settings Form Title'
      end
      object Label14: TLabel
        Left = 8
        Top = 328
        Width = 70
        Height = 13
        Caption = 'Settings Memo'
      end
      object CheckListBox1: TCheckListBox
        Left = 8
        Top = 120
        Width = 481
        Height = 161
        ItemHeight = 13
        PopupMenu = PopupMenu2
        TabOrder = 0
      end
      object Edit10: TEdit
        Left = 8
        Top = 288
        Width = 265
        Height = 21
        TabOrder = 1
        Text = 'Add To Registry'
      end
      object CheckBox2: TCheckBox
        Left = 8
        Top = 8
        Width = 153
        Height = 25
        Caption = 'Use Installation Settings'
        TabOrder = 2
      end
      object Button3: TButton
        Left = 288
        Top = 288
        Width = 65
        Height = 25
        Caption = 'Add'
        TabOrder = 3
        OnClick = LisaSetting
      end
      object Edit11: TEdit
        Left = 8
        Top = 64
        Width = 265
        Height = 21
        TabOrder = 4
        Text = 'What to install?'
      end
      object Memo2: TMemo
        Left = 8
        Top = 344
        Width = 481
        Height = 65
        TabOrder = 5
      end
      object StaticText1: TStaticText
        Left = 368
        Top = 288
        Width = 109
        Height = 17
        Caption = 'Right Click To Specify'
        TabOrder = 6
      end
      object StaticText2: TStaticText
        Left = 368
        Top = 304
        Width = 61
        Height = 17
        Caption = 'The File List'
        TabOrder = 7
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Special'
      ImageIndex = 4
      object Label15: TLabel
        Left = 8
        Top = 136
        Width = 21
        Height = 13
        Caption = 'Text'
      end
      object Label16: TLabel
        Left = 8
        Top = 208
        Width = 21
        Height = 13
        Caption = 'Text'
      end
      object Label17: TLabel
        Left = 8
        Top = 256
        Width = 70
        Height = 13
        Caption = 'Run Command'
      end
      object Label18: TLabel
        Left = 8
        Top = 296
        Width = 264
        Height = 13
        Caption = '%path is the directory where the program will be installed'
      end
      object Label19: TLabel
        Left = 8
        Top = 344
        Width = 21
        Height = 13
        Caption = 'Text'
      end
      object Label20: TLabel
        Left = 8
        Top = 56
        Width = 125
        Height = 13
        Caption = 'Special Settings Form Title'
      end
      object CheckBox3: TCheckBox
        Left = 8
        Top = 112
        Width = 137
        Height = 17
        Caption = 'Restart After Installation'
        TabOrder = 0
      end
      object Edit13: TEdit
        Left = 8
        Top = 152
        Width = 265
        Height = 21
        TabOrder = 1
        Text = 'Restart after installation?'
      end
      object CheckBox4: TCheckBox
        Left = 8
        Top = 184
        Width = 121
        Height = 17
        Caption = 'Start After Installation'
        TabOrder = 2
      end
      object Edit14: TEdit
        Left = 8
        Top = 224
        Width = 265
        Height = 21
        TabOrder = 3
        Text = 'Start program when installer finish'
      end
      object Edit15: TEdit
        Left = 8
        Top = 272
        Width = 273
        Height = 21
        TabOrder = 4
        Text = '%path\Program.exe'
      end
      object CheckBox5: TCheckBox
        Left = 8
        Top = 320
        Width = 257
        Height = 17
        Caption = 'Add ShortCut To Desktop And QuickLaunch Bar'
        TabOrder = 5
      end
      object Edit16: TEdit
        Left = 8
        Top = 360
        Width = 273
        Height = 21
        TabOrder = 6
        Text = 'Add Shortcut icon to desktop?'
      end
      object CheckBox6: TCheckBox
        Left = 8
        Top = 24
        Width = 137
        Height = 17
        Caption = 'Use Special Settings'
        TabOrder = 7
      end
      object Edit17: TEdit
        Left = 8
        Top = 72
        Width = 265
        Height = 21
        TabOrder = 8
        Text = 'Final settings'
      end
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 16
    Width = 193
    Height = 417
    Caption = 'Summary'
    TabOrder = 1
  end
  object Button4: TButton
    Left = 8
    Top = 456
    Width = 81
    Height = 25
    Caption = 'Make Install'
    TabOrder = 2
    OnClick = MakeInstall
  end
  object Button5: TButton
    Left = 104
    Top = 456
    Width = 81
    Height = 25
    Caption = 'Close'
    TabOrder = 3
    OnClick = CloseForm
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 152
    Top = 128
  end
  object PopupMenu1: TPopupMenu
    Left = 152
    Top = 16
    object Kustuta1: TMenuItem
      Caption = 'Remove'
      OnClick = RemSetting
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 152
    Top = 48
    object FileList1: TMenuItem
      Caption = 'Files List'
      OnClick = TeeFileList
    end
  end
end
