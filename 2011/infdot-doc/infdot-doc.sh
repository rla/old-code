#!/bin/bash

DOC_HOME=/home/raivo/Desktop/doc

redcloth -o html $1 | \
cat $DOC_HOME/intermediate/header.html - $DOC_HOME/intermediate/footer.html | \
xsltproc --novalid --encoding utf8 $DOC_HOME/templates/template.xsl - | \
tidy -quiet -utf8 -i -asxml --tidy-mark no --wrap 100 -output ${1%.textile}.html
