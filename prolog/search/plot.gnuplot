#!/usr/bin/gnuplot

# Määra väljundiks PostScript fail

set term post
set out "tulemus.ps"

# Telgede nimed

set xlabel "sisendi suurus"
set ylabel "tuletussamme"

set title "Koos A* esimese versiooniga"

# Joonistame graafikud

plot 'a-tarn.dat' title "a-tarn" smooth unique, \
     'iter-suv.dat' title "iter.-suv." smooth unique, \
     'laiuti.dat' title "laiuti" smooth unique, \
     'a-tarn-q.dat' title "a-tarn-q" smooth unique

set title "Ilma kehva A* versioonita"

# Graafikud ilma "ebaõnnestunud" a-tärnita

plot 'iter-suv.dat' title "iter.-suv." smooth unique, \
     'laiuti.dat' title "laiuti" smooth unique, \
     'a-tarn-q.dat' title "a-tarn-q" smooth unique

# Väikese sisendi jaoks

set title "Väikese sisendi jaoks koos A* esimese versiooniga"

plot 'a-tarn-s.dat' title "a-tarn" smooth unique, \
     'iter-suv-s.dat' title "iter.-suv." smooth unique, \
     'laiuti-s.dat' title "laiuti" smooth unique, \
     'a-tarn-q-s.dat' title "a-tarn-q" smooth unique

# Graafikud ilma "ebaõnnestunud" a-tärnita

set title "Väikese sisendi jaoks ilma A* esimese versioonita"

plot 'iter-suv-s.dat' title "iter.-suv." smooth unique, \
     'laiuti-s.dat' title "laiuti" smooth unique, \
     'a-tarn-q-s.dat' title "a-tarn-q" smooth unique
