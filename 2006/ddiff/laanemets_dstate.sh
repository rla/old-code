#!/bin/sh
##############################################################################
#                                                                            #
#                                                                            #
# Programm etteantud kataloogi (ilma alamkataloogiteta) oleku fikseerimiseks #
# olekufailis. Igal kataloogil on olemas oma olekufail, mida tähistatakse    #
# parasjagu vaadeldavas kataloogis peidetud failina .dstate. Fail sisaldab   #
# kirjeid iga kaustas asuva faili kohta (arvestades ka linke). Kirjed on     #
# omavahel eraldatud reavahetusega (/n), kirje väljad aga küsimärgiga (?).   #
#                                                                            #
# Väljad (vasakult paremale):                                                #
#                                                                            #
#   faili nimi, omanik, grupp, õigused, suurus, muutmise kuupäev, räsi       #
#                                                                            #
# Raivo Laanemets, rlaanemt@ut.ee                                            #
#                                                                            #
##############################################################################

USAGE="Kasutamine: laanemets_dstate.sh [-d kaust] [-o tööfail] [-h] [-v]"
VALJUND=".dstate"
D="."
VERBOSE=0
while getopts d:o:hv OPTION ;
do
    case "$OPTION" in
        v) VERBOSE=1 ;;
        d) D="$OPTARG" ;;
        o) VALJUND="$OPTARG" ;;
        h) echo $USAGE ;
           exit 0
           ;;
    esac
done

#Kontrollime, kas anti ette kaust.
if [ -d $D ]; then

  #Kausta oleku faili nimi
  SFILE="$D/$VALJUND"

  #Kontrollime olekufaili olemasolu,
  #kui olemas, siis kustutame

  if [ -f $SFILE ]; then
    `rm $SFILE`
  fi
  
  #Ühilduvuse huvides kaotame ära lokaalse
  #kuupäevaformaadi, vastasel korral on ls -l väljundi
  #parsimine liiga keeruline.
  
  LANG=C
  export LANG &1>/dev/null
  
  for f in `ls -1 $D`
  do
    if [ -f $D'/'$f ] ; then
    
      #Tööprotsessi näitamine kasutajale,
      #väljastame parasjagu töödeldava faili nime.
      
      if [ $VERBOSE -gt 0 ]; then
        echo $f
      fi
    
      #Arvutame räsi
      HASH=`md5sum -b "$D/$f" | cut -c 0-32`
      
      #Ülejäänud info faili kohta, kasutame awk'i ls'i rea
      #jagamiseks väljadeks, väljade vahele paigutame märgi ?.
      #On ebatõenäoline, et leiame ? kuskilt mujalt (näiteks faili
      #nimest)      
      DATA=`ls -l "$D/$f" | awk '{print "'$f'?" \$3 "?" \$4 "?" \$1 "?" \$5 "?" \$6 " " \$7 " " \$8;}'`

      #Kirjutame tulemuse faili
      echo "$DATA?$HASH" >> $SFILE
    
    fi
  done
  exit 0  
fi
