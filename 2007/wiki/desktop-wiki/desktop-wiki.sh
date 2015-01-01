#!/bin/sh

DESKTOPWIKI_HOME=/home/raivo/programming/java/wiki/desktop-wiki

java -cp "$DESKTOPWIKI_HOME/lib/text-template.jar:$DESKTOPWIKI_HOME/lib/rl-common.jar:$DESKTOPWIKI_HOME/lib/parser-tokenizer.jar:$DESKTOPWIKI_HOME/lib/wiki-parser.jar:$DESKTOPWIKI_HOME/lib/nondet-java.jar:$DESKTOPWIKI_HOME/desktop-wiki.jar:$DESKTOPWIKI_HOME/lib/commons-io.jar:$DESKTOPWIKI_HOME/lib/commons-net.jar" ee.pri.rl.wiki.desktop.Main $*