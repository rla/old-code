#!/bin/sh

./puhasta.sh
latex lahendite_loendamine.tex
latex lahendite_loendamine.tex
latex lahendite_loendamine.tex
dvipdf lahendite_loendamine.dvi
dvips -o lahendite_loendamine.ps lahendite_loendamine.dvi
rm -rf valjund
mkdir valjund
cp lahendite_loendamine.dvi valjund
cp lahendite_loendamine.pdf valjund
cp lahendite_loendamine.ps valjund
./puhasta.sh
