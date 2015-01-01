#!/bin/sh

DOTVIEW_HOME=/home/raivo/programming/java/wiki/parser-tokenizer
DOTVIEW_LIBS=/home/raivo/programming/java/wiki/lib

java -cp "$DOTVIEW_LIBS/rl-common.jar:$DOTVIEW_LIBS/commons-cli.jar:$DOTVIEW_LIBS/nondet-java.jar:$DOTVIEW_HOME/parser-tokenizer.jar" ee.pri.rl.tokenizer.support.dot.DotView $*