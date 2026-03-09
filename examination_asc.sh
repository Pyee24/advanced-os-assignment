#!/bin/bash

SUBMISSION_DIR="submissions"



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


