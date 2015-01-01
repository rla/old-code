#!/bin/sh
# Shell wrapper to the uploader.
# Raivo Laanemets, rlaanemt@ut.ee, 29.10.06

pl -q -t top -s /usr/local/bin/upload.pl -- $*
