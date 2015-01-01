'YhClick Sub include fail
'by Raivo Laanemets 2003
Sub YhClick
  Dim mess As String
  Server=ServEdit.Text
  User=UserEdit.Text
  Pass=PassEdit.Text
  Pop3Port=val(PortEdit.Text)
  
  If Len(Server)=0 Or Len(User)=0 Or Len(Pass)=0 Or Len(PortEdit.Text)=0 Then
    Showmessage("Viga kasutaja andmetes.")
    Exit Sub
  End If
  
  pop3prt=pop3.Connect(Server, Pop3Port) 'Ühendamine
  If pop3prt<=0 Then
    Showmessage("Ühendust ei saa.")
    Exit Sub
  End If
  ServGauge.Position=10
  ServRich.Clear
  
  POP3Read(pop3prt)
  
  Pop3Write("USER " +user) 'user info saatmine
  mess=POP3Read(pop3prt)
  
  ServGauge.Position=15
  If Ucase$(Left$(mess, 4))="-ERR" Then
    ShowMessage("Vale kasutajanimi.")
    Call ErrQuit
    ServGauge.Position=0
    Exit Sub
  End If

  Pop3Write("PASS " +pass)
  mess=POP3Read(pop3prt)
  
  ServGauge.Position=20
  If Ucase$(Left$(mess, 4))="-ERR" Then
    ShowMessage("Vale parool/kasutajanimi.")
    Call ErrQuit
    ServGauge.Position=0
    Exit Sub
  End If
  
  'Nüüd peaksime juba sees olema
  Call GetN  
  
  Connected=1
  YhBtn.Enabled=0
  KatkBtn.Enabled=1
  ServEdit.Enabled=0
  UserEdit.Enabled=0
  PassEdit.Enabled=0
  PortEdit.Enabled=0
End Sub