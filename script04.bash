#!/bin/bash
#collect list of processes
listprocesses=$(ps -aux | awk '{print $2;}')

for pid in $listprocesses
do
    process_dir=/proc/"$pid"
    if [[ -d "$process_dir" ]]
    then
        ppid=$(cat "$process_dir"/status | awk '{if ($1 == "PPid:") print $2;}')
        sum_exec_runtime=$(cat "$process_dir"/sched | awk '{if ($1 == "se.sum_exec_runtime") print $3;}')
        nr_switches=$(cat "$process_dir"/sched | awk '{if ($1 == "nr_switches") print $3;}')
        art=$(echo "scale=4; $sum_exec_runtime/$nr_switches" | bc)
        echo "$pid $ppid $art" >> list.tmp
    fi
done

sort -n --key=2 list.tmp | awk '{print "ProcessID=" $1 " : Parent_ProcessId=" $2 " : Averrage_Running_Time=" $3;}' > list.txt
rm list.tmp
exit 0
