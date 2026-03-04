#!/bin/bash
critical_pid=("1" "$$")
ARCHIVE_DIR="ArchiveLogs"
SIZE_LIMIT=$((50*1024*1024))
ARCHIVE_MAX=$((1024*1024*1024))
LOG_FILE="system_log.txt"

log_action()
{
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

show_cpu_memory()
{
    echo "CPU and Memory usage"
    top -b -n1 | head -n5
    log_action "CPU and Memory usage viewed"

}

show_top_processes()
{
    echo "Top 10 Memory using processes"
    ps aux --sort=-%mem | head -n 11
    log_action "Top processes listed"
}

terminate_process()
{
    read -p "Enter process PID" pid

    for cp in "${critical_pid[@]}"; do
        if [[ "$pid" == "$cp" ]]; then
            echo "Error:Attempted to terminate critical process"
            log_action "Blocked attempt to terminate critical process pid = $pid"

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
            kill "$pid" && echo "Process $pid terminated"
            log_action "Terninated process $pid"
            ;;
        *)
            echo "Cancelled"
            log_action "Cancelled termination for $pid"
             ;;
    esac
}

disk_inspection_archive()
{
    read -p "Enter directory for inspection: " dir

    if [[ ! -d "$dir" ]]; then
        echo "Directory not found"
        return
    fi

    echo "Disk usage for $dir"
    du -sh "$dir"
    log_action "Inspected disk usage for $dir"

    mkdir -p "$ARCHIVE_DIR"

    echo "Logging large files in excess of 50mb in $dir directory"
    mapfile -t large_files < <(find "$dir" -type f -name "*.log" -size +${SIZE_LIMIT}c 2>/dev/null)

    if [[ ${#large_files[@]} -eq 0 ]]; then
        echo "No large log files in $dir"
        return
    fi

    for f in "${large_files[@]}"; do
        echo "Compressing $f"
        base=$(basename "$f")
        ts=$(date '+%Y%m%d_%H%M%S')
        tar_name="${ARCHIVE_DIR}/${base}_${ts}.tar.gz"
        tar -czf "$tar_name" "$f"
        log_action "Compressed file $f down to $tar_name"
    done

    archive_size=$(du -sb "$ARCHIVE_DIR" | awk '{print $1}')

    if (( archive_size > ARCHIVE_MAX )); then
        echo "WARNING Archive Log exceeds 1GB , current size ${archive_size} bytes"
        log_action "Archive Log exceeded 1GB , current size ${archive_size} bytes"
    fi
}

menu() {
    while true; do  
        echo "CCCU Data Centre Process and Resource Management System"
        echo "1) Display CPU and Memory Usage"
        echo "2) List top 10 Memory processes"
        echo "3) Terminate a process"
        echo "4) Inspect a Disk and Log Archiving"
        echo "5) Exit system"

        read -p "Please choose an option from the list: " choice

        case "$choice" in
            1)
                show_cpu_memory
                ;;
            2)
                show_top_processes
                ;;
            3)
                terminate_process
                ;;
            4)
                disk_inspection_archive
                ;;
            5)
                read -p "Are you sure you wish to exit? (Y/N): " ans
                case "$ans" in
                    [Yy])
                        echo "You have exited the system"
                        log_action "System exited"
                        exit 0
                        ;;
                    *)
                        echo "Exit cancelled"
                        ;;
                esac
                ;;
            *)
                echo "Invalid Option"
                ;;
        esac
    done
}



menu
