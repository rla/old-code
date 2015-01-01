object Form1: TForm1
  Left = 134
  Top = 146
  Width = 508
  Height = 319
  Caption = 'Simple Web Editor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 273
    Height = 273
    Align = alLeft
    Caption = 'Objects File'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 48
      Width = 93
      Height = 13
      Caption = 'Number of records: '
    end
    object Bevel1: TBevel
      Left = 8
      Top = 72
      Width = 257
      Height = 9
      Shape = bsBottomLine
    end
    object Label2: TLabel
      Left = 8
      Top = 88
      Width = 28
      Height = 13
      Caption = 'Name'
    end
    object Label3: TLabel
      Left = 120
      Top = 88
      Width = 24
      Height = 13
      Caption = 'Type'
    end
    object Bevel2: TBevel
      Left = 8
      Top = 128
      Width = 257
      Height = 9
      Shape = bsBottomLine
    end
    object Label4: TLabel
      Left = 8
      Top = 144
      Width = 20
      Height = 13
      Caption = 'FTP'
    end
    object Label5: TLabel
      Left = 8
      Top = 160
      Width = 31
      Height = 13
      Caption = 'Server'
    end
    object Label6: TLabel
      Left = 8
      Top = 184
      Width = 22
      Height = 13
      Caption = 'User'
    end
    object Label7: TLabel
      Left = 8
      Top = 208
      Width = 23
      Height = 13
      Caption = 'Pass'
    end
    object Label8: TLabel
      Left = 8
      Top = 256
      Width = 33
      Height = 13
      Caption = 'Status:'
    end
    object Label9: TLabel
      Left = 48
      Top = 256
      Width = 64
      Height = 13
      Caption = 'disconnected'
    end
    object Label10: TLabel
      Left = 8
      Top = 232
      Width = 16
      Height = 13
      Caption = 'Dir.'
    end
    object Edit1: TEdit
      Left = 8
      Top = 16
      Width = 177
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object Button1: TButton
      Left = 192
      Top = 16
      Width = 73
      Height = 25
      Caption = 'Open'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 192
      Top = 48
      Width = 73
      Height = 25
      Caption = 'View'
      TabOrder = 2
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 192
      Top = 104
      Width = 73
      Height = 25
      Caption = 'Add'
      TabOrder = 3
      OnClick = Button3Click
    end
    object Edit2: TEdit
      Left = 8
      Top = 104
      Width = 105
      Height = 21
      TabOrder = 4
    end
    object ComboBox1: TComboBox
      Left = 120
      Top = 104
      Width = 65
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 5
      Items.Strings = (
        'HTML'
        'THTML'
        'CSS')
    end
    object Edit3: TEdit
      Left = 48
      Top = 160
      Width = 137
      Height = 21
      TabOrder = 6
      Text = 'ftp.rl.pri.ee'
    end
    object Edit4: TEdit
      Left = 48
      Top = 184
      Width = 137
      Height = 21
      TabOrder = 7
      Text = 'rlpri'
    end
    object MaskEdit1: TMaskEdit
      Left = 48
      Top = 208
      Width = 137
      Height = 21
      TabOrder = 8
      Text = '12345'
    end
    object Button6: TButton
      Left = 192
      Top = 160
      Width = 73
      Height = 25
      Caption = 'Update'
      TabOrder = 9
      OnClick = Button6Click
    end
    object Edit5: TEdit
      Left = 48
      Top = 232
      Width = 137
      Height = 21
      TabOrder = 10
      Text = 'cgi-bin'
    end
  end
  object GroupBox2: TGroupBox
    Left = 273
    Top = 0
    Width = 227
    Height = 273
    Align = alClient
    Caption = 'Objects'
    TabOrder = 1
    object ListBox1: TListBox
      Left = 2
      Top = 15
      Width = 129
      Height = 256
      Align = alLeft
      ItemHeight = 13
      TabOrder = 0
    end
    object Button4: TButton
      Left = 144
      Top = 16
      Width = 73
      Height = 25
      Caption = 'View code'
      TabOrder = 1
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 144
      Top = 48
      Width = 73
      Height = 25
      Caption = 'View data'
      TabOrder = 2
      OnClick = Button5Click
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Data files|*.dat'
    Left = 80
  end
  object IdFTP1: TIdFTP
    OnStatus = IdFTP1Status
    OnDisconnected = IdFTP1Disconnected
    OnConnected = IdFTP1Connected
    Left = 232
    Top = 208
  end
  object MainMenu1: TMainMenu
    Left = 136
    Top = 40
    object Fail1: TMenuItem
      Caption = 'Fail'
      object Ava1: TMenuItem
        Caption = 'Ava'
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Vlju1: TMenuItem
        Caption = 'V'#228'lju'
        OnClick = Vlju1Click
      end
    end
  end
end
