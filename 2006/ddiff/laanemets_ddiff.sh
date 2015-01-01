#!/bin/sh
##############################################################################
#                                                                            #
#                                                                            #
# Programm etteantud kataloogi (ilma alamkataloogiteta) oleku muutuste       #
# näitamiseks.                                                               #
# Raivo Laanemets, rlaanemt@ut.ee                                            #
#                                                                            #
##############################################################################

USAGE="Kasutamine: $0 [-d kaust] [-h]"
D='.'
while getopts d:h OPTION ;
do
    case "$OPTION" in
        d) D="$OPTARG" ;;
        h) echo "$USAGE" ;
           exit 0
           ;;
    esac
done

#Loome praegust hetke kajastava olekufaili.
laanemets_dstate.sh -d $D -o .dstate_current

#Võrdleme praegust ja eelmist olekufaili, selleks käivitame olekute
#võrdlemise skripti seal kaustas.
cd $D
laanemets_dstatediff.sh