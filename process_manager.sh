#!/bin/bash
critical_pid = ("1" "$$")
ARCHIVE_DIR = "ArchiveLogs"
SIZE_LIMIT = $((50*1024*1024))
ARCHIVE_MAX = $((1024*1024*1024))

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

    if ! ps -p "$pid" > /dev/null 2>&1; then
        echo " No active process of this PID"
        return
    fi
    

    read -p "Are you ure you wish to terminate this process $pid? (Y/N)" ans
    case "$ans" in
        [Yy])
            kill "$pid" && echo "Process $pid terminated";;
        *)
            echo "Cancelled" ;;
    esac
}

Disk_inspection_archive()
{
    read -p "Enter directory for inspection" dir

    if [[ ! -d "$dir"]]; then
        echo "Directory not found"
        return
    fi

    echo "Disk usage for $dir"
    du -sh "$dir"

    mkdir -p "$ARCHIVE_DIR"

    echo "Logging large files in excess of 50mb in $dir directory"
    mapfile -t large_files <(find "$dir" -type f -name "*.log" -size +" ${SIZE_LIMIT}c" 2>/dev/null)

    if [[ ${#large_files[@]} -eq 0]] then
        echo "No large log files in $dir"
        return
    fi

    for f in "${large_files[@]}"; do
        echo "Compressing $f"
        base=$(basename "$f")
        ts=$(date '+%Y%m%d_%H%M%S')
        tar_name="${ARCHIVE_DIR}/${base}_${ts}.tar.gz"
        tar -czf "$tar_name" "$f"
    done

    archive_size=$(du -sb "$ARCHIVE_DIR" | awk '{print $1}')

    if ((archive size > ARCHIVE_MAX)); then
        echo "WARNING Archive Log exceeds 1GB , current size ${archive_size} bytes"
    fi




}

show_cpu_memory

show_top_processes


