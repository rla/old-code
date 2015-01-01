$include "Rapidq.inc"
$include "myfunc.inc"
$typecheck on

declare sub dirchange
declare sub play_mp3
declare sub exitform
declare sub getmp3tag
declare sub id3tagclose
declare sub renamefail
declare sub teelist
declare sub teeplaylist
declare sub mp3ainult
declare sub pledit
declare sub pleditok
declare sub add_mp3
declare sub muuda_mp3_dir
declare sub dirc
declare sub dird
declare sub dire
declare sub pl_mp3
declare sub abi_menu
declare sub txt_ok
declare sub list_dir
declare sub list_ok
declare sub htmllist
declare sub tee_plok
declare sub auto_run
declare sub auto_ok
declare sub auto_cancel
declare sub auto_icon
declare sub renm_ok
declare sub renm_cl
declare sub chk_icons
declare sub delete_f

type tag 
  header As String * 3
  title As String * 30
  artist As String * 30
  album As String * 30
  aasta As String * 4
  comment As String * 30
  genre As Byte
end type  

dim id3tag as tag
dim form as qform
dim dirtree as qdirtree
dim filelist as qfilelistbox
dim mp3_player as qgroupbox
dim exitbtn as qbutton
dim fnimp3 as string *255
dim command as string
dim mp3btn as qbutton
dim id3form as qform
dim failn as string
dim uusnimi as string
dim teelistbtn as qbutton
dim teeplbtn as qbutton
dim checkmp3 as qcheckbox
dim playlists as qfilelistbox
dim settings as qgroupbox
dim plform as qform
dim pllist as qlistbox
dim flist as qfilelistbox
dim dirlist as qfilelistbox
dim dir_e as qcheckbox
dim dir_c as qcheckbox
dim dir_d as qcheckbox
dim plmp3ainult as qcheckbox
dim statusb as qstatusbar
dim mainmenu as qmainmenu
dim abimenu as qmenuitem
dim failmenu as qmenuitem
dim setmenu as qmenuitem
dim exitmenu as qmenuitem
dim txtform as qform
dim txtedit as qedit
dim listdir as qmenuitem
dim listdirf as qform
dim listedit as qedit
dim comedit as qedit
dim htmlbtn as qbutton
dim renmform as qform
dim grouppl as qgroupbox
dim groupdir as qgroupbox
dim groupfile as qgroupbox
dim teeplform as qform
dim teepledit as qedit
dim autorun as qbutton
dim autoform as qform
dim autoamp as qcheckbox
dim autoedit as qedit
dim icondlg as qopendialog
dim iconname as string
dim cdwdir as string 'cd-kirjutaja tht
dim autoname as qedit
dim chkicons as qcheckbox
dim renm_edit as qedit
dim deletef as qbutton

cdwdir="E:\"

iconname="C:\Cdprog\Ikoonid\cdrom3.ico"

dim error as long

chdir("E:\")

form.height=500
form.width=640
form.caption="mp3korrastaja2"
form.center

statusb.parent=form

mainmenu.parent=form
mainmenu.additems(failmenu,setmenu,abimenu)

abimenu.caption="Abi"
abimenu.onclick=abi_menu

failmenu.caption="&Fail"
failmenu.additems(exitmenu)

setmenu.caption="Settingud"
setmenu.additems(listdir)

exitmenu.caption="Exit"
exitmenu.onclick=exitform

listdir.caption="Listfdir"
listdir.onclick=list_dir

groupdir.top=10
groupdir.left=10
groupdir.caption="Kaustad"
groupdir.height=305
groupdir.width=195
groupdir.parent=form

dirtree.parent=form
dirtree.left=20
dirtree.top=30
dirtree.width=175
dirtree.height=275
dirtree.InitialDir="E:\"
dirtree.OnChange=dirchange

groupfile.top=10
groupfile.left=210
groupfile.height=305
groupfile.width=170
groupfile.parent=form
groupfile.caption="Failid"

filelist.left=220
filelist.top=30
filelist.width=150
filelist.height=275
filelist.parent=form
filelist.mask="*.mp3"
filelist.directory=curdir$
filelist.OnDblClick=getmp3tag
filelist.showIcons=true

grouppl.left=10
grouppl.top=325
grouppl.width=195
grouppl.height=105
grouppl.caption="Mp3 playlistid"
grouppl.parent=form

playlists.left=20
playlists.top=340
playlists.width=175
playlists.height=80
playlists.parent=form
playlists.directory=curdir$
playlists.mask="*.m3u"
playlists.OnDblClick=pledit

mp3_player.top=10
mp3_player.left=400
mp3_player.height=305
mp3_player.width=180
mp3_player.caption="Tegevused"
mp3_player.parent=form

settings.top=325
settings.left=210
settings.height=105
settings.width=370
settings.caption="Settingud"
settings.parent=form

checkmp3.left=230
checkmp3.top=360
checkmp3.caption="Mp3 failid"
checkmp3.checked=true
checkmp3.parent=form
checkmp3.onclick=mp3ainult

chkicons.left=230
chkicons.top=380
chkicons.checked=true
chkicons.parent=form
chkicons.caption="Näita ikoone"
chkicons.onclick=chk_icons

exitbtn.left=450
exitbtn.top=275
exitbtn.caption="Välju"
exitbtn.onclick=exitform
exitbtn.parent=form

mp3btn.left=450
mp3btn.top=50
mp3btn.parent=form
mp3btn.caption="Kuula"
mp3btn.onclick=play_mp3

teelistbtn.left=450
teelistbtn.top=75
teelistbtn.parent=form
teelistbtn.caption="Tee list"
teelistbtn.onclick=teelist

teeplbtn.top=100
teeplbtn.left=450
teeplbtn.parent=form
teeplbtn.caption="Tee playlist"
teeplbtn.onclick=teeplaylist

htmlbtn.top=125
htmlbtn.left=450
htmlbtn.parent=form
htmlbtn.caption="Rename"
htmlbtn.onclick=htmllist

autorun.top=150
autorun.left=450
autorun.parent=form
autorun.caption="Autorun.ini"
autorun.onclick=auto_run

deletef.top=175
deletef.left=450
deletef.parent=form
deletef.caption="Kustuta"
deletef.onclick=delete_f

form.showmodal

sub dirchange
  filelist.directory=dirtree.directory
  playlists.directory=dirtree.directory
  chdir(dirtree.directory)
end sub


sub play_mp3
fnimp3=filelist.filename - curdir$ - "\"
run "C:/Program Files/Winamp/winamp.exe " +fnimp3  
end sub

sub exitform
form.close
end sub


dim artistt as string
dim titlet as string


sub getmp3tag
  failn=filelist.filename
  dim fail as qfilestream
  dim id3okbtn as qbutton
  dim title as qedit
  dim artist as qedit
  dim album as qedit
  dim comment as qedit
  dim aasta as qedit
  dim titlel as qlabel
  dim artistl as qlabel
  dim albuml as qlabel
  dim coml as qlabel
  dim aastal as qlabel
  dim rename_btn as qbutton

    fail.open(failn, fmOpenRead)
    fail.seek(fail.size-128,1)
    fail.readudt(id3tag)
    fail.close

    
        
    titlel.left=10
    titlel.caption="Pealkiri"
    titlel.top=20
    titlel.parent=id3form
    
    artistl.left=10
    artistl.caption="Esitaja"
    artistl.top=50
    artistl.parent=id3form
    
    albuml.left=10
    albuml.caption="Album"
    albuml.top=80
    albuml.parent=id3form
    
    coml.left=10
    coml.caption="Kommentaar"
    coml.parent=id3form
    coml.top=110
    
    aastal.left=10
    aastal.caption="Aasta"
    aastal.parent=id3form
    aastal.top=140
    
    aasta.width=50
    aasta.top=140
    aasta.left=80
    aasta.text=id3tag.aasta
    aasta.parent=id3form
    aasta.enabled=0
    
    comment.width=150
    comment.top=110
    comment.left=80
    comment.text=id3tag.comment
    comment.parent=id3form
    comment.enabled=0
    
    album.width=150
    album.top=80
    album.left=80
    album.text=id3tag.album
    album.parent=id3form
    album.enabled=0
    
    artist.width=150
    artist.top=50
    artist.left=80
    artist.text=id3tag.artist
    artist.parent=id3form
    artist.enabled=0
     
    title.width=150 
    title.top=20
    title.left=80
    title.text=id3tag.title
    title.parent=id3form
    title.enabled=0 
  
    id3okbtn.top=225
    id3okbtn.left=200
    id3okbtn.caption="OK"
    id3okbtn.onclick=id3tagclose 
    id3okbtn.parent=id3form
    
    rename_btn.top=225
    rename_btn.left=25
    rename_btn.caption="Rename"
    rename_btn.onclick=renamefail
    rename_btn.parent=id3form 
  
    id3form.height=300
    id3form.width=300
    id3form.BorderStyle=bsDialog
    id3form.caption=failn +" ID3tag info" -curdir$
    id3form.center
    id3form.showmodal
    
    artistt=artist.text
     
     
    
end sub

sub id3tagclose
  id3form.close
end sub

sub renamefail
  if len(curdir$) = 3 then
    uusnimi=curdir$ +lyhstr(id3tag.artist) +"-" +lyhstr(id3tag.title) +".mp3"
  else
    uusnimi=curdir$ +"\" +lyhstr(id3tag.artist) +"-" +lyhstr(id3tag.title) +".mp3"
  end if
  rename filelist.FileName, uusnimi
  if fileexists(uusnimi) then showmessage("Fail " +uusnimi +" ok")
end sub

sub teelist
  if filelist.itemcount=0 then 
    showmessage("Kausta error")
    exit sub
  end if  
  dim txtok as qbutton
  txtform.height=150
  txtform.width=250
  txtform.caption="Listi nimi"
  txtform.BorderStyle=bsDialog
  txtform.center
  
  txtedit.top=30
  txtedit.left=10
  txtedit.text="Cdname.txt"
  txtedit.parent=txtform
  
  comedit.top=60
  comedit.left=10
  comedit.text="kommentaar"
  comedit.parent=txtform
  
  txtok.top=60
  txtok.left=150
  txtok.caption="Ok"
  txtok.onclick=txt_ok
  txtok.parent=txtform
  
  txtform.showmodal
end sub

sub teeplaylist
    
    dim teeplok as qbutton 
    teeplform.height=100
    teeplform.width=250
    teeplform.caption="Playlisti nimi"
    teeplform.center
  
    teepledit.top=30
    teepledit.left=10
    teepledit.text="kõik"
    teepledit.parent=teeplform
  
    teeplok.top=30
    teeplok.left=150
    teeplok.caption="Ok"
    teeplok.onclick=tee_plok
    teeplok.parent=teeplform
   
    teeplform.showmodal
end sub

sub mp3ainult
  if checkmp3.checked then
  playlists.enabled=1
  filelist.mask="*.mp3"
  else 
  playlists.enabled=0
  filelist.mask="*.*"
  end if
end sub

sub pledit
  dim plokbtn as qbutton
  dim file as qfilestream
  dim ridu as integer
  dim s as string
  dim addmp3 as qbutton
  

  
  flist.top=20
  flist.left=10
  flist.width=150
  flist.height=200
  flist.parent=plform
  flist.directory=filelist.directory
  flist.OnDblClick=add_mp3
  
  dirlist.top=240
  dirlist.left=10
  dirlist.parent=plform
  dirlist.width=150
  dirlist.height=80
  dirlist.addfiletypes(ftdirectory)
  dirlist.delfiletypes(ftnormal)
  dirlist.onDblClick=muuda_mp3_dir
  dirlist.drive="C"
  
  dir_c.top=240
  dir_c.left=230
  dir_c.caption="C: ketas"
  dir_c.parent=plform
  dir_c.onclick=dirc
  dir_c.checked=true
  
  dir_d.top=265
  dir_d.left=230
  dir_d.caption="D: ketas"
  dir_d.onclick=dird
  dir_d.parent=plform
  
  dir_e.top=290
  dir_e.left=230
  dir_e.caption="E: ketas"
  dir_e.onclick=dire
  dir_e.parent=plform
  
  plmp3ainult.top=315
  plmp3ainult.left=230
  plmp3ainult.caption="Mp3 ainult"
  plmp3ainult.parent=plform
  plmp3ainult.onclick=pl_mp3
  
  addmp3.top=100
  addmp3.left=200
  addmp3.caption="Lisa->"
  addmp3.parent=plform
  addmp3.onclick=add_mp3
  
  pllist.top=20
  pllist.left=300
  pllist.width=150
  pllist.height=200
  pllist.parent=plform
  
  plform.height=400
  plform.width=480
  plform.caption="Playlisti sättimine"
  plform.center
  plform.BorderStyle=bsDialog

  
  file.open(playlists.filename, fmOpenRead)
  for ridu=0 to 500 do 
  s=file.readline
  if len(s)<>0 then pllist.additems(s)
  if s="" then ridu=500
  next
  
  plokbtn.top=250
  plokbtn.left=325
  plokbtn.caption="OK"
  plokbtn.onclick=pleditok
  plokbtn.parent=plform
  
  plform.showmodal
  file.close
  
end sub

sub pleditok
  plform.close
end sub

sub add_mp3
  pllist.additems(flist.fileName)
end sub

sub muuda_mp3_dir
chdir(dirlist.item(dirlist.itemindex)-"["-"]")
dirlist.directory=curdir$
flist.directory=curdir$
end sub

sub dirc
  if dir_c.checked then 
  dirlist.drive="C"
  dir_d.checked=false
  dir_e.checked=false
  chdir("C:\")
  flist.directory=curdir$
  end if
end sub

sub dird
  if dir_d.checked then 
  dirlist.drive="D"
  dir_c.checked=false
  dir_e.checked=false
  chdir("D:\")
  flist.directory=curdir$
  end if
end sub

sub dire
  if dir_e.checked then
  dirlist.drive="E"
  dir_c.checked=false
  dir_d.checked=false
  chdir("E:\")
  flist.directory=curdir$
  end if
end sub

sub pl_mp3
  if plmp3ainult.checked then 
  flist.mask="*.mp3"
  else
  flist.mask="*.*"
  end if
end sub

sub list_dir
  dim listok as qbutton
  
  listdirf.height=100
  listdirf.width=250
  listdirf.borderstyle=bsDialog
  listdirf.caption="Listifailide kaust"
  
  listedit.top=30
  listedit.left=10
  listedit.text="C:\cddir"
  listedit.parent=listdirf
  
  listok.top=30
  listok.onclick=list_ok
  listok.left=150
  listok.caption="Ok"
  listok.parent=listdirf
  
  listdirf.center
  listdirf.showmodal
end sub

sub list_ok
  dim dirfile as qfilestream
   
  if len(listedit.text) < 3 then
    showmessage("Kausta error")
  else
    mkdir(listedit.text)
    if direxists(listedit.text) then
      showmessage("Kaust " +listedit.text +" ok")
      dirfile.open("C:\Cdprog\cddir.ini",fmOpenWrite)
      dirfile.writeline(listedit.text)
      dirfile.close
      listdirf.close
    else
      showmessage("Kausta error")
    end if    
  end if
end sub

sub txt_ok
  dim i as integer
  dim cdstr as string
  dim cddirf as qfilestream
  dim txtlistf as qfilestream
  
  cddirf.open("C:\Cdprog\cddir.ini",fmOpenRead)
  cdstr=cddirf.readline
  cddirf.close
  txtlistf.open(cdstr +"\" +txtedit.text,fmCreate)
  txtlistf.writeline(comedit.text)
  
  for i=0 to filelist.itemcount-1 do
    txtlistf.writeline(filelist.item(i))
  next
  txtlistf.writeline(date$)
  txtlistf.close
  if fileexists(cdstr +"\" +txtedit.text) then showmessage("List tehtud edukalt")
  txtform.close
  
end sub

sub htmllist
  if filelist.filename="" then
    showmessage("Vali üks fail kõigepealt")
    exit sub
  end if
  dim renmok as qbutton
  dim renmcl as qbutton
  dim renm_vana as qedit
  dim vanan as qlabel
  dim uusn as qlabel
  renmform.height=200
  renmform.width=300
  renmform.caption="Mp3-e nime muutmine"
  renmform.borderStyle=bsDialog
  renmform.center
  
  vanan.top=10
  vanan.left=10
  vanan.caption="Vana"
  vanan.parent=renmform
  
  uusn.top=50
  uusn.left=10
  uusn.caption="Uus"
  uusn.parent=renmform
  
  renm_vana.top=10
  renm_vana.left=50
  renm_vana.width=225
  renm_vana.text=filelist.filename-curdir$
  renm_vana.enabled=false
  renm_vana.parent=renmform
  
  renm_edit.top=50
  renm_edit.left=50
  renm_edit.width=225
  renm_edit.text="Uus nimi"
  renm_edit.parent=renmform
  
  renmcl.top=125
  renmcl.left=25
  renmcl.caption="Tühista"
  renmcl.parent=renmform
  renmcl.onclick=renm_cl
  
  renmok.top=125
  renmok.left=200
  renmok.caption="Ok"
  renmok.parent=renmform
  renmok.onclick=renm_ok
  
  renmform.showmodal
end sub

sub tee_plok
  dim plfnim as string
  dim plfile as qfilestream
  dim ki as integer
  if len(teepledit.text) < 3 then 
    showmessage("Failinime error")
    exit sub
  else 
    if len(curdir$) = 3 then
      plfnim=curdir$ +teepledit.text +".m3u"
    else
      plfnim=curdir$ +"\" +teepledit.text +".m3u"
    end if     
    plfile.open(plfnim,fmCreate)
    for ki=0 to filelist.itemcount-1 do
      plfile.writeline(filelist.item(ki))
    next
    plfile.close
  end if 
  if fileexists(plfnim) then showmessage("Playlist " +teepledit.text +" edukalt tehtud") 
  teeplform.close
end sub

sub auto_run
  dim autook as qbutton
  dim autocancel as qbutton
  dim autoicon as qbutton
  dim cdnimi as qlabel

  autoform.height=250
  autoform.width=280
  autoform.caption="Tee autorun.ini fail"
  autoform.borderstyle=bsDialog
  autoform.center
  
  cdnimi.left=20
  cdnimi.top=80
  cdnimi.caption="Cd nimi"
  cdnimi.parent=autoform
  
  autoedit.left=75
  autoedit.top=80
  autoedit.width=100
  autoedit.text="Cdname"
  autoedit.parent=autoform
  
  autoamp.left=20
  autoamp.top=40
  autoamp.caption="open=Play.exe"
  autoamp.checked=1
  autoamp.parent=autoform
  
  autocancel.left=25
  autocancel.top=150
  autocancel.caption="Tühista"
  autocancel.onclick=auto_cancel
  autocancel.parent=autoform
  
  autoicon.left=100
  autoicon.top=150
  autoicon.caption="Cd ikoon"
  autoicon.onclick=auto_icon
  autoicon.parent=autoform
   
  autook.left=175
  autook.top=150
  autook.caption="Ok"
  autook.parent=autoform
  autook.onclick=auto_ok
   
  autoform.showmodal
  
end sub

sub auto_ok
  dim autofail as qfilestream
  autofail.open(cdwdir +"autorun.inf",fmCreate)
  autofail.writeline("[autorun]")
  if autoamp.checked then
    autofail.writeline("open=Play.exe")
  else  
  end if
  autofail.writeline("icon=" +getfile(iconname))
  autofail.close
  copyfile(iconname,cdwdir +getfile(iconname))
  copyfile("C:\Cdprog\Progs\Play.exe", cdwdir +"Play.exe")
  if fileexists(cdwdir +"autorun.ini") then showmessage("Autorun fail edukalt tehtud")
  autoform.close
end sub

sub auto_cancel
  autoform.close
end sub

sub auto_icon
  icondlg.caption="Cd ikoon"
  icondlg.initialdir="C:\Cdprog\Ikoonid"
  icondlg.filter="Ikoonid | *.ico"
  if icondlg.execute then
    iconname=icondlg.filename
  end if
end sub

sub renm_ok
  if len(curdir$) > 3 then
    rename filelist.filename, curdir$ +"\" +renm_edit.text
  else 
    rename filelist.filename, curdir$ +renm_edit.text
  end if  
  if fileexists(curdir$ +renm_edit.text) then showmessage("Rename edukas")
  renmform.close
end sub

sub renm_cl
  renmform.close
end sub

sub chk_icons
  if chkicons.checked then
    filelist.ShowIcons=true
  else
    filelist.ShowIcons=false
  end if    
end sub

sub delete_f
  if filelist.filename="" then 
    showmessage("Vali kõigepealt fail, mida kustutada")
    exit sub
  else
    kill filelist.filename
  end if
  if fileexists(filelist.filename) then
  else 
    showmessage("Faili " +filelist.filename +" kustutamine edukas")
  end if        
end sub