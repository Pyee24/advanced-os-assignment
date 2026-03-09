#!/bin/bash

SUBMISSION_DIR="submissions"
LOG_SUBMISSIONS="submission_log.txt"
ACCOUNT_STATUS="account_status.txt"
LOGIN_LOG="login_log.txt"



mkdir -p "$SUBMISSION_DIR"

file_validation()
{
    local file="$1"

    if [[ ! -f "$file" ]]; then
        echo "Error: File does not exist."
        return 1
    fi

    ext="${file##*.}"

    if [["$ext" != "pdf" && "$ext" != "docx" ]]; then
        echo "Error: Only pdf and docx file allowed."
        return 1
    fi

    max_size=$((5 * 1024 * 1024))
    size=$(stat -c%s "$file")

    if ((size > max_size)); then
        echo "Error: File exceeds 5MB size limit."
        return 1
    fi

    return 0


}

check_duplicates()
{
    local file="$1"
    local filename=$(basename "$file")

    if [[ -f "$SUBMISSION_DIR/$filename"]]; then
        if cmp -s "$file" "$SUBMISSION_DIR/$filename"]]; then
            echo "Duplicate files detected."
            return 1
        fi
    fi

    return 0
}

assignment_submission()
{
    read -p "Enter File path: " file
    
    file_validation "$file" || return
    check_duplicates "$file" || return

    filename=$(basename "$file")
    cp "$file" "$SUBMISSION_DIR/$filename" 

    echo "$(date): Submitted $filename" >> "$LOG_SUBMISSIONS"
    echo "Successful Submission"



}

submission_check()
{
    read -p "Enter name of file to check: " filename

    if [[ -f $SUBMISSION_DIR/$filename]]; then
        echo "File has been submitted"
    else
        echo "File has not been submitted"
    fi
}

list_submissions()
{
    echo "Submission List"
    ls -1 "$SUBMISSION_DIR"

}

login_simulation()
{
    local user="student"

    failed_attempts=$(grep "$user:" "$ACCOUNT_STATUS" | cut -d':' -f2)
    locked=$(grep "$user:" "$ACCOUNT_STATUS" | cut -d':' -f3)

    if [[ -z "failed_attempts"]]; then
        failed_attempts=0
        locked=0
        echo "$user:0:0" > "$ACCOUNT_STATUS"
    fi

    if (( locked == 1)); then
        echo "Account is locked due to repeated failure"
        return
    fi

    read -p "Enter password (sim password is password1): " password
    time=$(date +%s)

    last_attempt=$(tail -1 "$LOGIN_LOG" | awk '{print $NF}' )

    if [[ -n "$last_attempt"]]; then
        time_diff=$((time - last_attempt))
        if ((diff < 60 )); then
            echo "Suspicious behaviorui detected: Too many login attempts within 60 seconds"
            return
        fi
    fi

    echo "$(date) User=$user Attempt_time=$time" >> "$LOGIN_LOG"

    if [[ "$password" == "password1" ]]; then
        echo "Successful login"
        sed -i "s/$user:.*/$user:0:0/" "$ACCOUNT_STATUS"
    else
        echo "Incorrect password"
        failed_attempts=$((failed_attempts + 1))

        if ((failed_attempts >= 3 )); then
            echo "Too many attempts , account locked"
            sed -i "s/$user:.*/$user:$failed_attempts:1/" "$ACCOUNT_STATUS"
        
        else
            sed -i "s/$user:.*/$user:$failed_attempts:0/" "$ACCOUNT_STATUS"
        fi
    fi
}
