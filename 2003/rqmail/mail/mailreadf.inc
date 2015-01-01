Function SMTPRead(prt As Integer) As String
  Dim Time As Integer
  Dim Temp As String
  Temp=""
  Time=Timer
  SMTPReply:
    If smtp.IsServerReady(prt) Then Temp=smtp.ReadLine(prt): GoTo SMTPDone
    If Timer-Time<5 Then GoTo SMTPReply
  SMTPDone:  
  SMTPRead=Temp
End Function

Function POP3Read(prt As Integer) As String
  Dim Time As Integer
  Dim Temp As String
  Temp=""
  Time=Timer
  POP3Reply:
    If pop3.IsServerReady(pop3prt) Then Temp=pop3.ReadLine(pop3prt): GoTo Pop3Done
    If Timer-Time<5 Then GoTo POP3Reply
  POP3Done:
  If Ucase$(Left$(Temp, 3))="+OK" Then RichBlue(Temp)
  If Ucase$(Left$(Temp, 4))="-ERR" Then RichRed(Temp)
  POP3Read=Temp
End Function