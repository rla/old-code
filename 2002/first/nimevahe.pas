program nimevahetaja;
  var nimi:string;
      peren:string;
      eesn:string;
      tyhik:byte;
begin
write('Sisesta oma nimi ');
readln(nimi);
tyhik:=pos(' ',nimi);
peren:=copy(nimi,tyhik+1,length(nimi));
eesn:=copy(nimi,1,tyhik-1);
write(peren,', ',eesn);
readln;
end.