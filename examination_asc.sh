#!/bin/bash

SUBMISSION_DIR="submissions"
LOG_SUBMISSIONS="submission_log.txt"



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
    
}
