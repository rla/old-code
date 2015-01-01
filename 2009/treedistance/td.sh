#!/bin/sh

CP=treedistance.jar

for JAR in `ls lib/*.jar`
do
	CP=$CP:$JAR
done

java -Xmx512M -cp $CP ee.pri.rl.treedistance.Main $*