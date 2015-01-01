Sub GetN 'käivitatakse kohe peale ühendamist 
  Dim mess As String
  Dim ii As Integer
  Dim Gpos As Integer
  
  Pop3Write("STAT")
  mess=Pop3Read(pop3prt)
  
  mess=Right$(mess, Len(mess)-Instr(0, mess, " "))
  mess=Left$(mess, Instr(0, mess, " ")-1)
  
    ServGauge.Position=30
  
  N=val(mess)
  Gpos=Round(70/N)
  
  For ii=1 To N Do
    GetNMess(ii)
    ServGauge.Position=ServGauge.Position+Gpos
  Next
  
  MailTime.Enabled=1
  ServGauge.Position=100
End Sub

Sub GetNMess(mitm As Integer) 'saab N nda teate päise
  Dim mess As String
  Dim Subject As String
  Dim From As String
  Dim Date As String

  Pop3Write("TOP " +str$(mitm) +" 0")
  Mlist.AddItems str$(mitm)
  
  Do
    mess=Pop3Read(pop3prt)
    If Ucase$(Left$(mess, 7))="SUBJECT" Then Subject=Right$(mess, Len(mess)-8)
    If Ucase$(Left$(mess, 4))="FROM" Then From=Right$(mess, Len(mess)-5)
    If Ucase$(Left$(mess, 4))="DATE" Then Date=Right$(mess, Len(mess)-5)
  Loop Until Left$(mess, 1)="." Or Ucase$(Left$(mess, 4))="-ERR" 
  
  Mlist.AddSubItem mitm-1, Left$(Subject, Len(Subject)-1)
  Mlist.AddSubItem mitm-1, Left$(From, Len(From)-1)
  Mlist.AddSubItem mitm-1, Left$(Date, Len(Date)-1)
End Sub

Sub MailTimeSub
  Dim MT As Integer
  Dim mess As String
  Dim ii As Integer
  
  Pop3Write("STAT")
  mess=Pop3Read(pop3prt)

  mess=Right$(mess, Len(mess)-Instr(0, mess, " "))
  mess=Left$(mess, Instr(0, mess, " ")-1)
  
  MT=val(mess) 'MT-uute mailide arv
  
  If MT<>N Then
    MailTime.Enabled=0
    ShowMessage("Saabunud on " +str$(MT-N) +" uut maili")
    MailTime.Enabled=1
  Else
    Vaadatud=0
    Exit Sub  
  End If
  
  'Kui uusi maile on saabunud siis->
  For ii=1 To MT-N Do
    GetNMess(N+ii)
  Next
  N=MT
  MailLabel.Caption="Kokku " +str$(N) +" maili."
End Sub