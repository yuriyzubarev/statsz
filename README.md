StatsZ
=====

HTTP server that consumes numbers at preset intervals and returns summary statistics.

Inspiration
-----------

Inspired by a need to make sense of constant stream of hundreads of measurements, and do it in automated and self adjusting way. The name is inspired by StatsD.

Status
------

This is a **prototype**. Hence Bash, AWK and 20-Python-lines server.

> A prototype is an early sample, model, or release of a product built to test a concept or process or to act as a thing to be replicated or learned from.

Usage
-----

    1. git clone ...
    2. cd statsz
    3. python server.py
    4. http://localhost:8080/?name=foo&value=7&datetime=1416854891

response

        {
          "before": {
            "count": 0
          },
          "after": {
            "count": 1,
            "mean": 7,
            "p2": 7,
            "p9": 7,
            "p25": 7,
            "median": 7,
            "p75": 7,
            "p91": 7,
            "p98": 7,
            "min": 7,
            "max": 7
          }
        }
    
... repeat

    5. http://localhost:8080/?name=foo&value=7&datetime=1416854891

response

        {
          "before": {
            "count": 9,
            "mean": 6.11111,
            "p2": 5,
            "p9": 5,
            "p25": 6,
            "median": 6,
            "p75": 7,
            "p91": 7,
            "p98": 7,
            "min": 5,
            "max": 7
          },
          "after": {
            "count": 10,
            "mean": 6.2,
            "p2": 5,
            "p9": 5,
            "p25": 6,
            "median": 6,
            "p75": 7,
            "p91": 7,
            "p98": 7,
            "min": 5,
            "max": 7
          }
        }

... repeat

Resources
---------

http://en.wikipedia.org/wiki/Seven-number_summary

http://stackoverflow.com/questions/9789806/command-line-utility-to-print-statistics-of-numbers-in-linux

http://www.acmesystems.it/python_httpserver

http://pymotw.com/2/BaseHTTPServer/
