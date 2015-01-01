#!/bin/sh

#Faili üleslaadija mooload.com'i
#Tagastab faili URL'i
#Raivo Laanemets
#copyright (c) 2005


#Kasutamine: mooload <faili nimi> <kiirusepiirang>

echo `curl --limit-rate $2 -s -F "filetoupload=@$1;submitted=Upload File" www.mooload.com/index.php | sed -n "s/.*\(http:\/\/www.mooload.com\/file.php?file=files.*$1\).*/\1/p"`
