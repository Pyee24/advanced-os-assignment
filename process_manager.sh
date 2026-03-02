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

    for pd in "$critical_pid)

    
}

show_cpu_memory

show_top_processes


