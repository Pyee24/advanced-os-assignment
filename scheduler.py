#!/usr/bin/env python3

JOB_QUEUE = "job_queue.txt"
COMPLETED_JOB = "completed_job.txt"

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
        
         