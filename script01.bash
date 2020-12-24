#!/bin/bash
#count processes
ps aux | awk '{if ($1 == "user") print}' | wc -l >myprocesses.txt
#write pid:name
ps aux | awk '{if ($1 == "user") print $2" : "$11}'>>myprocesses.txt
exit 0
