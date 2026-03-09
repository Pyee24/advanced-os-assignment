import os 
import time

SUBMISSION_DIR = "submissions"

if not os.path.exists(SUBMISSION_DIR):
    os.makedirs(SUBMISSION_DIR)


def file_validation(filename):
    allowed_filename = [".pdf" , ".docx"]

    if not any(filename.endswith(name) for name in allowed_filename)
        return False, ("Invalid file type")

    try:
        size = os.path.getsize(filename) / (1024 * 1024)
            if size > 5:
                return False, ("File is too large")
    except FileNotFoundError
        return False, "File doesnt exist"
    
    return True, "File passed validation"

def duplicate_detection(filename):
    with open(filename, "rb") as new_file:
        new_data= new_file.read()
    
    for exisiting in os.listdir(SUBMISSION_DIR):
        exisiting_path = os.path.join(SUBMISSION_DIR, exisiting)

        with open(exisiting_path, "rb") as old_file:
            if old_file.read() == new_data:
                return True
    
    return False


