#!/bin/bash
#check proc dir
MRAM=0
procid=""

IFS=$'\n'
for proc_folder in $(ls -d /proc/[0-9]*)
do
    if [[ -f "$proc_folder"/statm ]]
    then
        page_number=$(cat "$proc_folder"/statm | awk '{print $2;}')
        ram_usage=$(("$page_number" * 4))

        if [[ "$ram_usage" -gt "$max_ram_usage" ]]
        then
            MRAM="$ram_usage"
            procid=$(cat "$proc_folder"/status | awk -F":" '{if ($1 == "Pid") print $2;}' | tr -d "[\t\s]")
        fi
    fi
done

echo "proc result - pid: $procid usage of ram: $MRAM"
top -b -n1 -o RES | head -n 8 | tail -n 1 | awk '{print "top result -  pid: " $1 " usage of ram: " $6}'
exit 0
 1 | awk '{print "TOP_RESULT | PID: " $1 " RAM_USAGE: " $6}'
exit 0
