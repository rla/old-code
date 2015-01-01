object KuhuForm: TKuhuForm
  Left = 217
  Top = 164
  BorderStyle = bsDialog
  Caption = 'Where to install'
  ClientHeight = 350
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = KuhuClose
  OnShow = KuhuStart
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 48
    Width = 66
    Height = 13
    Caption = 'Pick Directory'
  end
  object Label2: TLabel
    Left = 16
    Top = 280
    Width = 137
    Height = 13
    Caption = 'Required space: 10Mb'
  end
  object PathEdit: TEdit
    Left = 16
    Top = 248
    Width = 393
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 16
    Top = 312
    Width = 97
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = KuhuCanc
  end
  object Button2: TButton
    Left = 128
    Top = 312
    Width = 97
    Height = 25
    Caption = 'Next ->'
    TabOrder = 2
    OnClick = KuhuOk
  end
  object DirList: TShellTreeView
    Left = 16
    Top = 72
    Width = 393
    Height = 161
    ObjectTypes = [otFolders]
    Root = 'rfDesktop'
    UseShellImages = True
    AutoRefresh = False
    Indent = 19
    ParentColor = False
    RightClickSelect = True
    ShowRoot = False
    TabOrder = 3
    OnClick = MuudaPath
  end
end
