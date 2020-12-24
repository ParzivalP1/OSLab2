#!/bin/bash
#check proc dir
save_rchar()
{
    if [[ -f "$1".tmp ]]
    then
        rm "$1".tmp
    fi

    for proc_dir in $(ls -d /proc/[0-9]*)
    do
        if [[ -f "$proc_dir"/io && -f "$proc_dir"/status && -f "$proc_dir"/cmdline ]]
        then
            rchar=$(cat "$proc_dir"/io | awk -F":" '{if ($1 == "rchar") print $2;}' | tr -d "[\t\s]")
            pid=$(cat "$proc_dir"/status | awk -F":" '{if ($1 == "Pid") print $2;}' | tr -d "[\t\s]")
            cmd=$(cat "$proc_dir"/cmdline | tr -d '\0')
            echo "$pid|$rchar|$cmd " >> "$1".tmp
        fi
    done
}

check_rchar()
{
    save_rchar start
    sleep "$1"
    save_rchar end

    if [[ -f 7.tmp ]]
    then
        rm 7.tmp
    fi

    IFS=$'\n'
    for line in $(cat end.tmp)
    do
        pid=$(echo "$line" | awk -F"|" '{print $1;}')
        rchar=$(echo "$line" | awk -F"|" '{print $2;}')
        cmd=$(echo "$line" | awk -F"|" '{print $3;}')
        start_rchar=$(cat start.tmp | awk -F"|" -v pid="$pid" '{if ($1 == pid) print $2;}')

        if [[ -n "$start_rchar" ]]
        then
            rchar=$(("$rchar" - "$start_rchar"))
        fi

        echo "$pid|$cmd|$rchar" >> 7.tmp
    done

    cat 7.tmp | sort -n --key=3 --field-separator="|" | tail -n 3 

    rm 7.tmp
    rm start.tmp
    rm end.tmp
}

check_rchar 10s
exit 0
 10s
exit 0
