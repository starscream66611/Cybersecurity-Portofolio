# Investigation 2 - Authentication Brute Force Attempt 

Im using hydra to brute force authentication on a victim-server.

The goal in here is learning the pattern of bruteforce attack on Splunk.

# Attacking Victim
! Attack is in a control Home Lab environment

The command that im gonna use here is: 
- Attempt 1 (Failed)
    hydra -l admin -P /opt/SecLists/Passwords/Common-Credentials/xato-net-10-million-passwords-100.txt ssh://172.19.0.3 -t 2 -V

    ![alt text](<../screenshots/Screenshot 2026-09-01 at 12.18.33 PM.png>)

- Attempt 2 (Success)
    hydra -l admin -P passwords.txt ssh://172.19.0.3 -t 2 -V

    ![alt text](<../screenshots/Screenshot 2026-09-01 at 12.19.25 PM.png>)

# Investigation on Splunk

im using query index="cybersoc" host="victim-server" to check the logs on victim-server.

- Failed Authentication Attempt
    ![alt text](<../screenshots/Screenshot 2026-09-01 at 12.02.13 PM.png>)
    ![alt text](<../screenshots/Screenshot 2026-09-01 at 12.03.15 PM.png>)

    Failed brute force attempt could be recognized by many failed authenticatin messaged shown in Splunk.

- Success Attempt

    ![alt text](<../screenshots/Screenshot 2026-09-01 at 12.07.55 PM.png>)
    ![alt text](<../screenshots/Screenshot 2026-09-01 at 12.08.57 PM.png>)

    accepted passwords indicate that the brute force attack are success.

- Pattern of Attack

    - Many failed authentication attempt indicate a brute force attack.
    - The number of an attempt is not normal.
    - Leading to succes or trying another way to get access to the victim.

# Query Learning

- To search failed attempt directly

    index="cybersoc" host="victim-server" "Failed Password"

    ![alt text](<../screenshots/Screenshot 2026-09-01 at 12.30.34 PM.png>)

- To search succes attempt

    index="cybersoc" host="victim-server" "Accepted Password"

    ![alt text](<../screenshots/Screenshot 2026-09-01 at 12.31.09 PM.png>)

- To extract attacker IP 

    index=cybersoc host=victim-server source="/shared-logs/auth.log" "Failed password"
    | rex "from (?<src_ip>\d+\.\d+\.\d+\.\d+)"

- Analyzing the IP

    | stats count by src_ip

    ![alt text](<../screenshots/Screenshot 2026-09-01 at 12.38.27 PM.png>)

    To count how many attempt conducted by the attacker IP.

    