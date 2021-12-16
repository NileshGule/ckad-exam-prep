#!/usr/bin/python3
## import the necessary modules

import time
import socket

## use an ongoing while loop to generate output
while True:
    ## set the hostname and current date
    host = socket.gethostname()
    date = time.strftime("%Y-%m-%d %H:%M:%S")

    ## convert the date output to a string
    now = str(date)

    ## open hte file named date in append mode
    ## append output of hostname and time
    f = open("date.out", "a")
    f.write(now + "\n")
    f.write(host + "\n")
    f.close()

    ## sleep for 5 seconds then continue the loop
    time.sleep(5)