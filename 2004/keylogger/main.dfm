object Form1: TForm1
  Left = 265
  Top = 209
  BorderStyle = bsNone
  Caption = 'Winsys'
  ClientHeight = 31
  ClientWidth = 104
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 8
    Top = 8
  end
  object NMFTP1: TNMFTP
    Port = 21
    ReportLevel = 0
    OnSuccess = NMFTP1Success
    Vendor = 2411
    ParseList = False
    ProxyPort = 0
    Passive = False
    FirewallType = FTUser
    FWAuthenticate = False
    Left = 56
    Top = 8
  end
end
