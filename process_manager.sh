#!/bin/bash
critical_pid = ("1" "$$")

show_cpu_memory()
{
    echo "CPU and Memory usage"
    top -b -n1 | head -n5

}

show_top_processes()
{
    echo "Top 10 Memory using processes"
    ps aux --sort=-%mem | head -n 11
}

terminate_process()
{
    read -p "Enter process PID" pid

    for cp in "${critical_pid[@]}" ; do
        if [[ "pid" == "$cp"]] ; then 
            echo "Attempted to terminate critical process"
            return
        fi
    done

    

    
}

show_cpu_memory

show_top_processes


