#!/bin/sh
#
# Shell script to start the server
# Raivo Laanemets, summer 2006
#

if [ -f server.log ]; then
	rm -f server.log
fi

nohup pl -q -t start_server -s misjonarid_http.pl > server.log &