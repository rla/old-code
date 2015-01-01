'myfuncs.inc
function tyhik(s as string) as string
  dim i as integer
  dim lenn as integer
  lenn=len(s)
  for i=0 to lenn do
  if s[i]=" " then 
    s=delete$(s,i,1)
    s=insert$("_",s,i)
  end if  
  next
  tyhik=s
end function

function lyhstre(s as string) as string
  dim a as integer
  dim vahet as string
  a=instr(1,s,chr$(0))
  vahet=left$(s,a-1)
  if len(vahet) = 0 then
    a=instr(1,s," ")
    vahet=left$(s,a-1)
  end if
  lyhstr=vahet  
end function 

function lyhstr(s as string) as string
  dim count as integer
  dim temp as integer
  for count=1 to len(s) do
    temp=instr(0,s, chr$(32))
    if temp<>0 then s=delete$(s,temp,1)
    if temp>1 then s=insert$("_",s,temp)
  next
  for count=1 to len(s) do
    if right$(s,1)="_" then s=delete$(s,len(s),1)
  next  
    lyhstr=s
end function

function getfile(path as string) as string
  dim kord as integer
  dim posit as integer
  dim tmpstr as string
  tmpstr=path
  for kord=1 to 20 do
    posit=instr(1,tmpstr,"\")
    if posit=0 then kord=20
    tmpstr=delete$(tmpstr,1,posit)
  next
  getfile=tmpstr  
end function

function copyfile(algfile as string, loppfail as string) as long
  dim algf as qfilestream
  dim loppf as qfilestream
  copyfile=0
    algf.open(algfile,fmOpenRead)
    loppf.open(loppfail,fmCreate)
    loppf.copyfrom(algf,0)
    algf.close
    loppf.close
    if fileexists(loppfail) then copyfile=1
end function
dim sak as string * 30
sak="        testi seda sitta" 
print lyhstr(sak) +"lop"
print chr$(32)

sleep 4