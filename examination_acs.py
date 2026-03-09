import os 
import time

SUBMISSION_DIR = "submissions"
SUBMISSION_LOG = "submission_log.txt"
LOGIN_LOG = "login_log.txt"

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

def submit_assignment():
    filename = input("Enter file path")

    validated,message = file_validation(filename)
    if not validated:
        print(message)
        return
    
    if duplicate_detection(filename):
        print("Duplicate file , rejected submission")
        return

    file_destination = os.path.join(SUBMISSION_DIR, os.path.basename(filename))
    with open(filename, "rb") as file, open(file_destination, "wb") as dest:
        dest.write(file.read())
    

def submission_list():
    file_list = os.listdir(SUBMISSION_DIR)
    if not file_list:
        print("No submissions")
    else:
        print("Submitted assignments:")
        for f in file_list:
            print(f)

def check_submission():
    filename = input("Input file for checking")
    if filename = os.listdir(SUBMISSION_DIR):
        print("File has been submitted")
    else:
        print("File not submitted")

def login_sim():
    username = input("Input username:")

    if failed_attempts.get(username, 0) >= 3
        print("Account locked")
        return
    
    now = time.time()
    if username in last_attempt_time and now - last_attempt_time[username] < 5:
        print("Too many attempts within 5 seconds, suspicsious behaviour detected ")
    
    last_attempt_time[username] = now


    password = input("Please input password(simulated password= password1):")

    if password == "password1":
        print("Successful login")
        failed_attempts[username] = 0
        
    else:
        print("Login unsuccessful")
        failed_attempts[username] = failed_attempts.get(username, 0) + 1


    



 



