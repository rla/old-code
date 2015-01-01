@echo off
TITLE Varese Kompilaator windowsile
ECHO Vares Makefile Windowsile:
ECHO ================================================================================
SET sdir=build
SET VOTMED=-sourcepath . -d %sdir%
@ERASE /S /Q %sdir%\*.*
echo Vanad class failide kustutuskäsk sooritatud ... OK
javac %VOTMED% Hoidla.java
javac %VOTMED% HoidlaException.java
javac %VOTMED% FileSystemStore.java
javac %VOTMED% Logija.java
javac %VOTMED% Andmeblokk.java
javac %VOTMED% Andmeruum.java
javac %VOTMED% AndmeException.java
javac %VOTMED% KohalikFail.java
javac %VOTMED% KaustaFailid.java
javac %VOTMED% Salvestaja.java
javac %VOTMED% FailiVotja.java
javac %VOTMED% Abimeetodid.java
javac %VOTMED% Andmeblokid.java
javac %VOTMED% Failid.java
javac %VOTMED% Crypto.java
javac %VOTMED% Main.java
echo Kui nyyd erroreid ei visanud võib õelda et kompleerumisega on ... OK