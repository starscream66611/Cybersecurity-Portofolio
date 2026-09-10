# TryHackMe - Log Traffic Analysis

Learning to Recognize Network Logs :
- Firewall Logs
- WAF Logs
- VPN Logs

The way im gonna learn is by answering TryHackMe room questions

To examine this logs im gonna use Splunk.

![alt text](<screenshot/Screenshot 2026-09-10 at 10.27.02 AM.png>)

# Investigation
1. Examine the firewall logs. What external IP performed the most reconnaissance?

    Reconnaissance is when one external ip trying to connect to internal ip with many different ports

    To search this on splunk, im using command: 

    index="network_logs" sourcetype=firewall_logs
    | stats count by src_ip

    and here's the result:
    ![alt text](<screenshot/Screenshot 2026-09-10 at 10.47.28 AM.png>)

    The screenshot showing that the ip 203.0.113.45 has 297 activity.

    Im gonna check if its reconnaissance or something else
    ![alt text](<screenshot/Screenshot 2026-09-10 at 10.52.36 AM.png>)
    ![alt text](<screenshot/Screenshot 2026-09-10 at 10.52.59 AM.png>)
    ![alt text](<screenshot/Screenshot 2026-09-10 at 10.53.26 AM.png>)

    The screenshot showing that ip 203.0.113.45 are connecting to the same destination ip 10.0.0.20 with a different ports.

    The evidence are aligned with recoinnassance behavior.

2. In the firewall log, Which internal host was targeted by scans?

    ![alt text](<screenshot/Screenshot 2026-09-10 at 10.57.29 AM.png>)

    Based on the screenshot, there's 127 events recorded for ip 10.0.0.20

3. Which username was targeted in VPN logs?

    Now, im changing the sourcetype of the logs into VPN logs.

    and to make my life easier im using im gonna use query stats count by so that a i could see which one recording the most activity.

    Full SPL Query: 
    index="network_logs" sourcetype=vpn_logs 
    | stats count by username

    ![alt text](<screenshot/Screenshot 2026-09-10 at 11.03.17 AM.png>)

    There's 135 activity recorded for username svc_backup

4. What internal IP was assigned after successful VPN login?

    ![alt text](<screenshot/Screenshot 2026-09-10 at 11.10.39 AM.png>)

    Based on this screenshot there are 2 events recorded for the ip 10.8.0.23

5. Which port was used for lateral SMB attempts?

    To find im gonna use Splunk Query:
    index="network_logs" alert="ET EXPLOIT Possible MS-SMB Lateral Movement"

    here's the result 
    ![alt text](<screenshot/Screenshot 2026-09-10 at 11.23.26 AM.png>)

    There's 32 events recorder and all of them are using port 445.

6. In the IDS logs, which host beaconed to the C2?

    Im gonna search the activity under this alert  
    alert="ET TROJAN Possible C2 Beaconing"

    The full Splunk query:

    index="network_logs" alert="ET TROJAN Possible C2 Beaconing" sourcetype=ids_logs 
    | stats count by src_ip

    ![alt text](<screenshot/Screenshot 2026-09-10 at 11.28.47 AM.png>)

    Based on the screenshot there's 80 activity recorded on ip 10.0.0.60

7. During the investigation, which IP was observed to be associated with C2?

    ![alt text](<screenshot/Screenshot 2026-09-10 at 11.31.46 AM.png>)

    Based on the screenshot IP that is associated with C2 is 198.51.100.77

8. Which host showed the exfiltration attempts?

    On the logs there's alert showing "ET INFO Possible HTTP POST Large Upload"

    This could be indicate a exfiltration attempts

    ![alt text](<screenshot/Screenshot 2026-09-10 at 11.36.48 AM.png>)

    There's 60 events being recorded for this alerts. To make it easy, im gonna use the filtering command to check the source ip of this activity.

    ![alt text](<screenshot/Screenshot 2026-09-10 at 11.39.12 AM.png>)

    There's 60 activity recorded for ip 10.0.0.51



