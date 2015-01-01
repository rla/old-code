# old-code

My personal projects that did not get their own repo. Some of them
use obscure and old languages and are not really compilable. Encoding
of all files has been changed to UTF-8.

Turbo Pascal source files were
originally encoded in CP437 (possibly using the EVS 8:1993 standard).

Delphi projects included lots of weird files in addition to Pascal source.
I removed most non-text ones.

Some Mirc scripts have symbols `` removed (color notation?). This means they
are probably not reusable.

Java projects that did not use Maven have their dependencies
(jar libraries) removed.

Things in this repo:

## 2001/2002

 * first - Turbo Pascal excercises from programming classes,
   the first programs I ever wrote.
 * addr - search utility for hostmasks in Mirc logs (Turbo Pascal)
 * dmflags - utility to calculate ZDaemon flags (RapidQ)
 * ftp - attempt on FTP client, unfinished (RapidQ)
 * irc - attempt on IRC client, unfinished (RapidQ)
 * html - HTML editor with FTP support (RapidQ)
 * jimweb - my homepage in 2002, (PHP, ISO-something encoding)
 * list - filesystem listing generator (RapidQ)
 * markmik - simple notes app (RapidQ)
 * max - the IRC trivia bot (Mirc script)
 * mp3_korrastaja - helper to fix MP3 file names and do some other stuff (RapidQ)
 * punktid2html - top players report generator for the max trivia bot (Delphi 6)
 * tpascal7kodukas - page with Turbo Pascal guides for beginners,
   the page was never finished

## 2003

 * doomserve - homepage for the first Estonian ZDaemon (0.99) server.
 * intaller - intaller generator (unfinished?) for Windows applications.
 * jweb - my old homepage. My old online identity was Jimmy Cool. Interestingly,
   it's still [hosted](http://www.hot.ee/j/jcweb/).
 * jcweb - another version of homepage. Uses lots of PHP.
 * list - list ported to Delphi from RapidQ.
 * max - next version of the IRC trivia bot (still a Mirc script).
 * oppeained - markmik ported to Delphi from RapidQ (with an intention
   to use it to record notes from schoolwork).
 * rqmail - mail (POP3/SMTP) client wrirren in RapidQ.
 * vanaweeb - the last version of my 2001/2002 homepage?
 * vastaja - answer-bot for the Mirc trivia script (Max).
 * opildata.pas - student database app in Turbo Pascal. After recoding
   to UTF-8 it might not always work correctly.
 * uss.pad - multiplayer worms game in Turbo Pascal. One of my largest
   applications then.

## 2004

 * admin_2 and admin_3 - versions of my PHP CMS.
 * csseditor - CSS editor writtent in Delphi.
 * keylogger - keylogger to log keystrokes and send them
   to remote FTP account. Also known as "lehmake" due to its cow icon.
 * kval - decimal-encoded bignum library for Turbo Pascal. This was
   part of examination to get a programmer's certification in high school.
 * mp3_korrastaja_v2 - rewrite of mp3_korrastaja in Delphi.
 * mp3center - my MP3 collection listing.
 * phpsite - another version of PHP CMS.
 * veeb2 - CGI-based web framework for Turbo Pascal/Delphi, was not finished.
 * wave.php - PHP script for wave effect in images.

## 2005

 * concise - my final PHP CMS. Logo was drawn by Rauno.
 * graafikud - generates some fancy graphs for math functions. Written in PHP.
 * hyperlinks - extract links from stdin. Written in C.
 * mooload - Bash script to upload files to Mooload.
 * srcdoc - Bash script to generate highlighted source documentation.
 * faeryattack.rq - RapidQ bot for faeryattack.com online game.
 * 3d - 3d rendering stuff in PHP.
 * bob.php - IRC bot in PHP.
 * indexer - reverse index generator (C) and a dumping script
   into a MySQL database (PHP).
 * vares - Java app for distributed data storage. Written for Java OOP
   course together with Rauno, Hanno and Kristjan (LRV Soft).
 * zone - another version of my homepage. Was hosted on a free zone.ee account.

## 2006

 * renderer - primitive 3d engine (Wolfenstein style) in Java.
 * 15-puzzle - a solver for 15-puzzle. Written in C and uses the A* algorithm.
 * missionaries-and-cannibals - solver for the puzzle. Written as web-based
   Prolog application.
 * neuralnets - tests how many neural network nodes fits in the RAM. Written in C.
 * ddfiff - records a directory state and allows to compare it with the current contents (Bash).
 * cleaner - cleans directory from backup files. Written in C.
 * indexer - full-text indexer for files. Supported partial words using a trigram
   character index. Written in C.
 * rewrite - like `sed` but way less powerful. Replaces text in a file.
 * java-indexer - full-text search in Java.
 * filedb - file size database in C++.
 * java-web-indexer - another full-text search indexer, this time as a Java web app.
 * JavaKode - parses Java source by iteratively removing strings and comments and
   other unneeded stuff.
 * mp3player - Java frontend for `mpg123`.
 * java-tts - a port of [TTS](http://kodu.ut.ee/~isotamm/zip/) to Java. I do not remember
   how complete it was. Some examples definitely worked.
 * raamatud - book database written in Perl.
 * java-3d - 3D stuff in Java. Attemp at Wolfenstein clone.

## 2007

 * jada-unikaalsus - different algorithms for detecting arrays with unique elements.
   Written in C.
 * jututuba - chatroom with tic-tac-toe. Written in Java.
 * oop_kodu - some small Java programs.
 * screenmaker - Java frontend to [mtn](http://moviethumbnail.sourceforge.net/).
 * wiki - wiki implementation in Java. Uses special grammar system for the wiki syntax
   specification.

## 2008

 * pcmm - remote-controlled HTTP daemons for mplayer and
   the [K8055](http://www.velleman.eu/products/view/?country=be&lang=en&id=351346) hardware.

## 2009

 * algorithmics - some solutions written for the Advanced Algorithmics course.
   Everything in Java.
 * treedistance - edit distance calculator for phylogenetic trees (Java).
 * treedistance_ordered - same as above but assumes ordered nodes (Java).
 * typing - Java applet for testing keyboard typing speed.
 * scientific-computing - some coursework code for the Distributed Systems course (Python).
 * trading - some algorithms for automated stock trading. Wrote these while taking
   the introductionary course to financial mathematics.

## 2010

 * http-check - HTTP monitor using the Ruby on Rails framework. Haml for views.

## 2011

 * qt-web-bridge - Java servlet to communicate with a command-line Qt app over stdio.
   Contains an example app (blog).
 * infdot-wicket - appempt to build common form elements on top of the Wicket framework.
 * infdot-serializer - serialization framework for Java where objects write themselves
   into data streams.
 * infdot-doc - documentation system built using XHTML, XSL transformations and Textile.
 * infdot-event-server - pubsub built onto Netty (a Java's network framework). Comes
   with an example project.
 * infdot-sql-java - SQL generator for Java.

Directory `euler` contains various solutions (written in 2005-2007) for Project Euler.

Directory `prolog` contains various Prolog code from 2006-2010.

Utilities:

 * cleaner.js - NodeJS script for validating/transcoding text files
   between ISO-8859-15, CP437 and UTF-8.

## Licenses

All written code is under MIT License unless stated otherwise in the file header.
I do not hold copyright for some icon and image files but I think all of them were
free for non-commercial usage.
