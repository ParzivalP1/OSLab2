#!/bin/bash
#last run process. Ignoring 5 strings(bash, awk, tail,head)
ps aux --sort=start_time | tail -n 6 | awk '{print $2 ": " $11}'|head -n 1
exit 0
