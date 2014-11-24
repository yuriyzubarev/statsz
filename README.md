StatsZ
=====

A network daemon listens for numbers and responds with statistics.

Inspiration
-----------

StatsZ is inspired by StatsD and the need not only to aggregate and plot data but also to learn about its properties.

Status
------

Currently this is a prototype with only two functional modes implemented through piping of known Linux programs.

Usage
-----

  echo "foo 10 8273456 last-10" | nc 127.0.0.1 7644

Resources
---------

http://stackoverflow.com/questions/9789806/command-line-utility-to-print-statistics-of-numbers-in-linux

http://en.wikipedia.org/wiki/Seven-number_summary

http://www.acmesystems.it/python_httpserver
http://pymotw.com/2/BaseHTTPServer/
