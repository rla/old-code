#!/bin/sh


#
#Värskendab lugude andmebaasi
#Raivo Laanemets

for f in `ls -1 $1`
do
  if [ -d $1'/'$d ] ; then
    `songs.sh $1'/'$d`
  fi
done
