import csv
import json
import os
from datetime import datetime

def run_attendance_check():
    # Load Config
    with open('Helpers/config.json', 'r') as f:
        config = json.load(f)

    # Archive old logs
    if os.path.exists('reports/reports.log'):
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        os.rename('reports/reports.log', f'reports/reports_{timestamp}.log.archive')

    # Process Data
    with open('Helpers/assets.csv', mode='r') as f, open('reports/reports.log', 'w') as log:
        reader = csv.DictReader(f)
        total = config['total_sessions']
        log.write(f"--- Attendance Report Run: {datetime.now()} ---\n")
        
        for row in reader:
            name = row['Names']
            attended = int(row['Attendance Count'])
            pct = (attended / total) * 100
            
            if pct < config['thresholds']['failure']:
                msg = f"URGENT: {name}, your attendance is {pct:.1f}%. You will fail this class."
                log.write(f"[{datetime.now()}] ALERT SENT TO {row['Email']}: {msg}\n")
                print(f"Logged alert for {name}")
            elif pct < config['thresholds']['warning']:
                msg = f"WARNING: {name}, your attendance is {pct:.1f}%. Please be careful."
                log.write(f"[{datetime.now()}] ALERT SENT TO {row['Email']}: {msg}\n")

if _name_ == "_main_":
    run_attendance_check()
