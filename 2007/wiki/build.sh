source environment.sh
export JAVA_HOME

cd rl-common
	ant -file build.xml clean copy-jar
cd -
cd nondet-java
	ant -file build.xml clean copy-jar
cd -
cd parser-tokenizer
	ant -file build.xml clean
	ant -file bootstrap.xml
	ant -file build.xml copy-jar
cd -
cd wiki-parser
	ant -file build.xml clean copy-jar
cd -
cd text-template
	ant -file build.xml clean copy-jar
cd -
cd desktop-wiki
	ant -file build.xml clean copy-jar
cd -