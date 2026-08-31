# Docker CyberSOC Lab Architecture

This project simulates a small Security Operations Center (SOC) environment using Docker containers. The lab generates realistic security events from an attacker machine against a vulnerable Linux server while Splunk continuously ingests and analyzes the generated logs.

The objective is to practice SOC analyst workflows such as log ingestion, attack detection, event investigation, and writing incident reports.

# Components

- Splunk Enterprise: SIEM platform for collecting, indexing, searching, and investigating security logs.

- Victim Server (Ubuntu 22.04): Target machine running Nginx, OpenSSH, and rsyslog. Generates authentication and web server logs.
- Attacker(Kali Linux): Simulates attacker activity using tools like Nmap, Gobuster, Curl, Hydra, and other reconnaissance tools.
- Shared Logs Volume: Docker volume that exposes victim logs to Splunk for continuous monitoring.

# Network Architecture

All containers communicate through an isolated Docker bridge network named soc-net.

Splunk monitors log files inside the shared /logs directory.
The attacker communicates only with the victim over the internal Docker network.
Splunk observes activity passively through collected logs.

This architecture mimics how a SIEM collects telemetry from monitored systems without directly interacting with attackers.

# Log Source

- access.log: HTTP requests received by the Nginx web server.

- auth.log: SSH authentication attempts and login activity.

- syslog: General Linux system events.

Each log is indexed into Splunk under the linux index.

# Detection Workflow

Attacker performs reconnaissance (Nmap, Gobuster, Curl, etc.). 

Victim services generate web and authentication logs. Log files are written into /var/log/lab/. 

Splunk continuously monitors /logs/access.log, /logs/auth.log, and /logs/syslog. 

Events become searchable in the linux index. SOC investigation is performed using Splunk Search Processing Language (SPL).

# Skills Learned 
- Docker networking.
- Linux log management.
- SIEM log ingestion.
- Splunk index and sourcetype configuration.
- Attack telemetry analysis.
- SOC investigation workflow.