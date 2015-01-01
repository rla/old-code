Sub TabChange
  Select Case Tab.TabIndex
    Case 0
      Panel0.Visible = True
      Panel1.Visible = False      
      Panel2.Visible = False
      Panel3.Visible = False 
      Panel4.Visible = False
    Case 1
      If Connected=0 Then 
        Panel1.Visible = False
        NotCon.Visible = True
      Else  
        Panel1.Visible=True
        NotCon.Visible=False
      End If  
      Panel0.Visible = False      
      Panel2.Visible = False
      Panel3.Visible = False
      Panel4.Visible = False 
    Case 2
      If Connected=0 Then 
        Panel2.Visible = False
        NotCon.Visible = True
      Else  
        Panel2.Visible=True
        NotCon.Visible=False
      End If
      Panel0.Visible = False
      Panel1.Visible = False      
      Panel3.Visible = False
      Panel4.Visible = False
    Case 3
      If Connected=0 Then 
        Panel3.Visible = False
        NotCon.Visible = True
      Else  
        Panel3.Visible=True
        NotCon.Visible=False
      End If
      Panel0.Visible = False
      Panel1.Visible = False      
      Panel2.Visible = False
      Panel4.Visible = False
    Case 4
      Panel0.Visible = False
      Panel1.Visible = False      
      Panel2.Visible = False
      Panel3.Visible = False
      Panel4.Visible = True
  End Select
End Sub