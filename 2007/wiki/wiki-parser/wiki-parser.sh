#!/bin/sh
WIKI_PARSER_HOME=/home/raivo/workspace/wiki-parser

java -cp "$WIKI_PARSER_HOME/lib/rl-common.jar:$WIKI_PARSER_HOME/lib/parser-tokenizer.jar:$WIKI_PARSER_HOME/wiki-parser.jar" ee.pri.rl.wiki.WikiPageParser $*