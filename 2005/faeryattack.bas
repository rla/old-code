$APPTYPE GUI
$TYPECHECK ON
$INCLUDE "rapidq.inc"

declare sub ButtonClick
declare function get_link(text as string) as string
declare sub end_fight
declare function get_data(link as string) as string
declare function get_win(text as string) as string
declare function web_connect() as long
declare function web_disconnect() as long

CONST TimeOut = 5 
CONST WM_SOCK = 10000

dim connected as long
Dim apos AS LONG
dim lpos as long
DIM Bytes AS LONG
DIM Server AS STRING, PathToFile AS STRING
DIM I AS INTEGER
DIM T# AS DOUBLE
dim loops as long
dim firsttime as long
dim nlink as string
dim wins as long
dim losts as long
dim Sock as integer    

SUB FormWndProc (Hwnd&, uMsg&, wParam&, lParam&)
    IF uMsg&=WM_SOCK THEN
       Connected=1
    END IF
END SUB


CREATE Form AS QForm
  Width=460
  Height=220
  Center
  Caption="Cheapie www.battlefaeries.com bot. Made by Killah. jc@starline.ee"
  Color=&HFFCA82
  BorderStyle=3
  CREATE Socket AS QSocket
    WMessage = WM_SOCK
  END CREATE
  CREATE URLLabel AS QLabel
    Left = 8
    Top = 12
    Caption = "Target shortcut"
  END CREATE
  CREATE Edit AS QEdit
    Left = 100
    Top = 8
    Width = 320
    height=15
    Text = "Paste target shortcut here"
    BorderStyle=0
  END CREATE
  CREATE Button AS QButton
    Left=8
    Top=150
    Caption = "Go win!"
    OnClick = ButtonClick
  END CREATE
  create maxdelaylabel as qlabel
    left=8
    top=40
    caption="Max delay"
  end create
  create maxdelayedit as qedit
    left=100
    top=40
    width=40
    text="3"
    height=15
    BorderStyle=0
  end create
  create mindelaylabel as qlabel
    left=150
    top=40
    caption="Min delay"
  end create
  create mindelayedit as qedit
    left=230
    top=40
    width=40
    text="1"
    height=15
    BorderStyle=0
  end create
  create numlabel as qlabel
    left=280
    top=40
    caption="Number of fights"
  end create
  create numedit as qedit
    left=380
    top=40
    width=40
    text="1324"
    height=15
    BorderStyle=0
  end create
  create targetlabel as qlabel
    left=8
    top=70
    caption="Target:"
  end create
  create wonlabel as qlabel
    left=8
    top=85
    caption="Wins: 0"
  end create
  create lostlabel as qlabel
    left=8
    top=100
    caption="Losts: 0"
  end create
  create matchlabel as qlabel
    left=8
    top=115
    caption="Match nr. 0"
  end create
  create byteslabel as qlabel
    left=8
    top=130
    caption="Bytes received: 0"
  end create
  'windows->
  WndProc = FormWndProc
  ShowModal
  '<-windows
END CREATE

sub ButtonClick
  call randomize
  dim textdata as string
  dim textlink as string
  dim firsttarget as string
  dim sleepingtime as long
  dim waitt as long
  dim minwait as long
  dim maxwait as long
  dim tmpt as long
  
  wins=0
  losts=0
  
  firsttarget=edit.text
  firsttarget=delete$(firsttarget, 1, instr(firsttarget, "/fight")-1)
  targetlabel.caption="Target: " +firsttarget
  
  maxwait=val(maxdelayedit.text)
  minwait=val(mindelayedit.text)
  
  loops=0
  textdata=get_data(firsttarget)
  textlink=get_link(textdata)
  
  do
    targetlabel.caption="Target: " +textlink
    
    matchlabel.caption="Match nr." +str$(loops+1) +" " +get_win(textdata)
    wonlabel.caption="Wins: " +str$(wins)
    lostlabel.caption="Lostst: " +str$(losts)
    
    textdata=get_data(textlink)  
    textlink=get_link(textdata)
    
    if textlink="/" then
      showmessage("Link error.")
      Edit.Text=""
      web_disconnect()
      exit sub
    end if  
    
    'random delay->
    waitt=minwait+rnd(maxwait-minwait)   
    tmpt=timer
    do
      DoEvents
    loop until (timer-tmpt)>=waitt
    '<-random delay
    
    loops=loops+1
  loop until loops>=val(numedit.text)
  
  call end_fight   
end sub

function get_link(text as string) as string
  dim link as string
  apos=instr(text, "fight.pse?seqid=")
  link=mid$(text, apos, 100)
  lpos=instr(link, ">")-2
  link=mid$(link, 1, lpos)
  link=replacesubstr$(link, "&amp;", "&")
  link="/" +link 
  get_link=link
end function

function get_win(text as string) as string
  dim winstr as string
  dim wpos as long
    wpos=instr(text, "You won against")
  if wpos>0 then
    winstr="You won!"
    inc(wins)
  else
    winstr="You lost!"
    inc(losts)
  end if
  get_win=winstr      
end function

sub end_fight
  web_disconnect()
  Showmessage("End of fight.")
  Edit.Text="Paste target shortcut here"
end sub

function web_connect() as long

  Sock=Socket.Connect("www.battlefaeries.com", 80)
  Connected=0

  T#=timer
  do
    DoEvents
  loop until Connected or (timer-T#)>=TimeOut

  if Connected=0 then
    ShowMessage "Could not make connection"
    Application.Terminate
  else
    Sock = Socket.MySocket
  end if
  
end function

function web_disconnect() as long
  Socket.Close(Sock)
  Connected=0
end function

function get_data(link as string) as string
dim text as string    
  if connected=0 then web_connect()
  
  Socket.WriteLine(Sock, "GET "+link+" HTTP/1.0")
  'Socket.WriteLine(Sock, "HOST: www.battlefaeries.com:80") 
  Socket.WriteLine(Sock, "")   
  Text=""
  do
    if Socket.IsServerReady(Sock) THEN
       Text=Text +Socket.Read(Sock, 32000)
       Bytes=Bytes +Socket.Transferred
       byteslabel.caption="Bytes received: " +str$(Bytes)
    end if
  loop until Socket.Transferred=0
  Socket.WriteLine(Sock, "")
  
  web_disconnect()
  get_data=text    
end function