#!/bin/bash
#list processes in sbin
ps aux | awk '{if ($11 ~ "^/sbin/*") print $2}'>sbinprocesses.txt
exit 0
