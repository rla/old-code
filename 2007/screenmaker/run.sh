#!/bin/sh

CP=screenmaker.jar

for JAR in `ls lib/*.jar`
do
	CP=$CP:$JAR
done

java -cp $CP ee.pri.rl.screens.Screens