#!/usr/bin/env python3
import time
import os
from datetime import datetime

JOB_QUEUE = "job_queue.txt"
COMPLETED_JOB = "completed_job.txt"
ROUND_ROBIN_TIME = 5
LOG_FILE="scheduler_log.txt"

def log_event(student_ID, job_name, scheduling_type):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(LOG_FILE, "a") as log:
        log.write(f"{timestamp} , {student_ID} , {job_name} , {scheduling_type}\n")

def load_jobs():
    jobs = []
    try:
        with open(JOB_QUEUE, "r") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                parts = line.split(",")
                if len(parts) != 4:
                    #fixed too many values error
                    continue
                sid, name, exec_time, priority = parts
                jobs.append({
                    "student_ID": sid,
                    "job_name": name,
                    "exec_time": int(exec_time),
                    "priority": int(priority),
                })
        return jobs
    except FileNotFoundError:
        return []


def save_job(jobs):
    with open(JOB_QUEUE, "w") as f:
        for job in jobs:
            f.write(f"{job['student_ID']},{job['job_name']},{job['exec_time']},{job['priority']}\n")


def completed_job(job):
    with open(COMPLETED_JOB, "a") as f:
        f.write(f"{job['student_ID']},{job['job_name']},{job['priority']}\n")

def view_job_queue():
    jobs = load_jobs()
    if not jobs:
        print("No pending jobs")
        return
    print("Pending job list")
    for j in jobs:
        print(f"Student: {j['student_ID']} | Job: {j['job_name']} | Time: {j['exec_time']}s | Priority: {j['priority']}")

def add_job():
    student_ID = input("Enter Student ID")
    job_name = input("Enter the name of the job")
    exec_time = int(input("Enter aporximate job completion time"))
    priority = int(input("Enter job priority (1 (lowest) -10 (highest) )"))

    job = f"{student_ID},{job_name},{exec_time},{priority}\n"
    with open(JOB_QUEUE, "a") as f:
        f.write(job)
    log_event(student_ID,job_name, "Job Addition")
    print("Job added successfully")
        
def round_robin():
    jobs = load_jobs()
    if not jobs:
        print("No currents jobs to process")
        return
    print("Round robin processing")
        
    while jobs:
        job=jobs.pop(0)
        log_event(job["student_ID"], job["job_name"], "ROUND ROBIN")

        if job["exec_time"] > ROUND_ROBIN_TIME:
            print(f"Running job : {job['job_name']}")
            time.sleep(1)
            job["exec_time"] -= ROUND_ROBIN_TIME
            jobs.append(job)
            
        else:
            print(f"Completing {job['job_name']} ")
            time.sleep(1)
            completed_job(job)
            
        save_job(jobs)
        
    print("Round robin complete")

def priority_scheduling():
    jobs = load_jobs()
    if not jobs:
        print("No currents jobs to process")
        return
    print("Priorty processing")

    jobs.sort(key=lambda x: x["priority"] , reverse=True)

    for job in jobs:
        log_event(job["student_ID"], job["job_name"], "PRIORITY")
        print(f"Running {job['job_name']} (Priority {job['priority']}) for {job['exec_time']}s")
        time.sleep(1)
        completed_job(job)

    save_job([])
    print("Priority scheudling complete")

def main_menu():
    while True:
        print("CCCU Job Scheduler")
        print("1) View pending jobs")
        print("2) Submit a job request")
        print("3) Begin job processing")
        print("4) View completed jobs")
        print("5) Exit")

        choice = input("Select option: ")

        if choice == "1":
            view_job_queue()

        elif choice == "2":
            add_job()

        elif choice == "3":
            print("Choose processing option")
            print("1) Round robin")
            print("2) Priority scheduling")
            option = input("Select option: ")

            if option == "1":
                round_robin()

            elif option == "2":
                priority_scheduling()

            else:
                print("Invalid option")

        elif choice == "4":
            if not os.path.exists(COMPLETED_JOB):
                print("No completed jobs")
            else:
                print("Completed jobs:")
                with open(COMPLETED_JOB, "r") as f:
                    print(f.read())

        elif choice == "5":
            exit_choice = input("Are you sure you wish to exit? (Y/N): ")
            if exit_choice.lower() == "y":
                print("Exiting now")
                break

        else:
            print("Invalid option")


if __name__ == "__main__":
    main_menu()

    



 






        

         