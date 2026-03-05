#!/usr/bin/env python3
import time
import os

JOB_QUEUE = "job_queue.txt"
COMPLETED_JOB = "completed_job.txt"
ROUND_ROBIN_TIME = 5

def load_jobs():
        jobs = []
        try:
            with open(JOB_QUEUE, "r") as f:
                for line in f
                    line = line.strip()
                    if not line:
                        continue
                    sid, name, exec_time, priority = line.split("|")
                    jobs.append({
                        "student_ID": sid
                        "job_name": name,
                        "exec_time": int(exec_time)
                        "priority": int(priority)
                    })
        except NoFileError
            pass
        return jobs

def save_job(jobs)
    with open(JOB_QUEUE, "w") as f:
        for job in jobs:
            f.write(f"{{job['student_ID']},{job['job_name']},{job['exec_time']},{job['priority']}\n}")

def completed_job(job)
    with open(COMPLETED_JOB, "w") as f:
        f.write(f"{job['student_ID']},{job['job_name']},{job['priority']}\n")

def view_job_queue()
    jobs = load_jobs
        if not jobs:
            print("No pending jobs")
            return
        print("Pending job list")
            for j in jobs
                print(f"Student: {j['student_ID']} | Job: {j['job_name']} | Time: {j['exec_time']}s | Priority: {j['priority']}")

def add_job()
    student_ID = input("Enter Student ID")
    job_name = input("Enter the name of the job")
    exec_time = int(input("Enter aporximate job completion time"))
    priority = int(input("Enter job priority (1-10)"))

    job = f"{student_ID},{job_name},{exec_time},{priority}"
    with open(JOB_QUEUE, "a") as f:
        f.write(job)
        
def round_robin()
    jobs = load_jobs()
        if not jobs:
            print("No currents jobs to process")
            return
        print("Round robin processing")
        
        while jobs:
            job=job.pop(0)

            if job["exec_time"] > ROUND_ROBIN_TIME:
                print(f"Running job : {job['job_name']}")
                time.sleep(1)
                job["exec_time"] -= ROUND_ROBIN_TIME
                jobs.append(job)
            
            else 
                print(f"Completing {job['job_name']} ")
                time.sleep(1)
                completed_job(job)
            
            save_job(jobs)
        
        print("Round robin complete")

def priorty_scheduling()
    jobs = load_jobs()
            if not jobs:
                print("No currents jobs to process")
                return
            print("Priorty processing")

            jobs.sort(key=lambda x: x["priorty"] , reverse=True)

            for job in jobs:
                print(f""Running {job['job_name']} (Priority {job['priority']}) for {job['exec_time']}s")
                time.sleep(1)
                completed_job(job)

            save_job([])
            print("Priority scheudling complete")





        

         