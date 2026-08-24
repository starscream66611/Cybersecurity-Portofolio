# LetsDefend - SOC Practice - 2

here im going to investigate 5 alert.

# Case 1
![alt text](<screenshot/Screenshot 2026-08-24 at 8.21.35 AM.png>)

The alert says "SOC288 - Security Software Discovery Detected"

first move is to collectiong IOC.

- IOC
    - Alert Type: Unauthorized Access
    - Host: Joe
    - IP Address:  172.16.17.212 - IPv4 - Private
    - L1 Note: "I detected Brute Force from IP 149.88.25.131
    - Alert Trigger: Possible Windows Firewall Enumeration Detected
    - Command: Get-NetFirewallRule | select DisplayName, Enabled, Description | Out-File -FilePath "C:\users\letsdefend\downloads\firewall_rules.txt" 

Now, the goal here is to determine whether the authorized user or attacker executed that command.

The important message is there's bruteforce attempt from IP 149.88.25.131

- Investigation

    This investigation starting on checking the the bruteforce attempt. My goal, is to check whether the brute force success or not.

    But before im investigating the log management, im going to use online threat intelligence for this IP 149.88.25.131

    - Evidence 1 - Online Threat Intelligence 
        - AbuseIpdb
        ![alt text](<screenshot/Screenshot 2026-08-24 at 8.48.17 AM.png>)

        IP 149.88.25.131 found in database with 62 times reported and the confidence of abuse is 2%.

        This IP is indicated a suspicious IP.

    - Evidence 2 - Brute Force Success - Log Management
    
        the starting point is 149.88.25.131 and see the activity from that IP.

        ![alt text](<screenshot/Screenshot 2026-08-24 at 8.32.15 AM.png>)

        We could see multiple failed logon attempt from IP 149.88.25.131. This confirming the brute force attack.

        ![alt text](<screenshot/Screenshot 2026-08-24 at 8.35.04 AM.png>)
        At 2024-06-04 10:59:46 IP 149.88.25.131 succesfully logged on to IP 172.16.17.212 over port 3389.

        !Port 3389 -> Default network port used for RDP(Remote Desktop Protocol)

        This event confirming that the brute force happen and the attempt of authentication is successful over RDP.

    Now to getting more information about this events. Im going to check IP 172.16.17.212 because of the succesful logon.

    To determining whether this is authorized user or attacker i need to see the activity on this IP.
    
    - Evidence 2 - Exporting Firewall Rules - Log Management

        Here's the activity on IP 172.16.17.212 after the success logon.
        ![alt text](<screenshot/Screenshot 2026-08-24 at 8.43.52 AM.png>)


        Im gonna start by identifying this logs containing the message.
        ![alt text](<screenshot/Screenshot 2026-08-24 at 8.45.19 AM.png>)
        
        - 1st LOG
            ![alt text](<screenshot/Screenshot 2026-08-24 at 9.25.39 AM.png>)
            ![alt text](<screenshot/Screenshot 2026-08-24 at 9.26.37 AM.png>)
            ![alt text](<screenshot/Screenshot 2026-08-24 at 9.26.57 AM.png>)

            The IP 172.16.17.212 accessing a powershell.exe

        - 2nd LOG
            ![alt text](<screenshot/Screenshot 2026-08-24 at 9.30.09 AM.png>)
            ![alt text](<screenshot/Screenshot 2026-08-24 at 9.29.10 AM.png>)

            On this log, there's a command being executed.

            The script is to exports a list of Windows Firewall rules into a text file called firewall_rules.txt in the user's Downloads folder.

        - 3rd LOG 
            ![alt text](<screenshot/Screenshot 2026-08-24 at 9.33.40 AM.png>)

            and firewall_rules.txt are opened using notepad.

        This activity are entering the discovery phase by enumerating firewall rules to understand which inbound and outbound rules were permitted. This information could be use to identify security controls, and potential path for lateral movement or persistance.

        after cheking the endpoint. IP 149.88.25.131 are not listed there.

        This is indicating that the event are an actual attack, starting from brute force attempt to discovery phase by exporting firewall rules to .txt file via powershell.

- Report

    Verdict: TRUE POSITIVE

    Report: 
    2024-06-04T07:04:31+03:00 IP 149.88.25.131 conducting brute force attempt to IP 172.16.17.212 over port 53(RDP). The attempt is succesfull, IP 149.88.25.131 running a script via powershell for exporting firewall rules to firewall_rules.txt in downloads directory.
    The file than being opened using NOTEPAD.EXE.

    Based on Online Threat Intel IP 149.88.25.131 indicating suspicious with 62 times reported and 2% of confidence. The IP 149.88.25.131 are not listed on endpoint.

- Remediation

    List of remediation:
    - Block IP 149.88.25.131