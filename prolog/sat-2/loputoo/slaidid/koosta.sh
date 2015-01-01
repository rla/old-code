#!/bin/sh

./puhasta.sh
latex slaidid.tex
dvipdf slaidid.dvi
dvips -o slaidid.ps slaidid.dvi
cp slaidid.dvi valjund
cp slaidid.pdf valjund
cp slaidid.ps valjund
./puhasta.sh
