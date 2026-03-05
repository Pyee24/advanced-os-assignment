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