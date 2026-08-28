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
    - Isolate IP IP 172.16.17.212 Joe
    - Reset Password

# Case 2 - Akira Ransomware

![alt text](<screenshot/Screenshot 2026-08-25 at 1.00.28 PM.png>)

In this case, the rule detected SOC328 - Akira Ransomware IOC's Detected.

First, move is to collecting IOC based on the alert alone.

- IOC

    - Hostname: Vergil
    - IP Address: 172.16.17.130
    - Hash: 2C7AEAC07CE7F03B74952E0E243BD52F2BFA60FADC92DD71A6A1FEE2D14CDD77
    - Starting Point:  email with an attached file named 'payment-confirmation-invoice-12345.zip'. 
    - File Path: C:\Users\LetsDefend\Downloads\payment-confirmation-invoice-12345\Payment Confirmation Invoice #12345.exe
    - Event Time : 2024-10-02T05:52:00+03:00


-  Online Threats Intel 

    Im gonna check the hash values by using online threats intel.
    ![alt text](<screenshot/Screenshot 2026-08-25 at 1.09.08 PM.png>)
    
    and the result indicating that this file is malicious.

To determine whether that this ransomware variant belong to Akira. Investigation on the behavior of the attack is needed.

Information that we had is, the files are from an email attachment which indicated a phishing attack.

and i need to gather knowledge of the characteristic of Akira type ransomware.

- Akira Ransomware:  
    associated with other groups known as Storm-1567, Howling Scorpius,
    Punk Spider, and Gold Sahara, and may have connections to the defunct Conti ransomware group.

    - Initial Access: spearphishing, abusing valid credentials, RDP, SSH, VPN.
    - Execution: Execute malicious command using VB Script.
    - Persistance and Discovery: creating an administrative account named itadm, Kerberoasting,  use credential
    scraping tools, like Mimikatz and LaZagne. for network discovery and
    reconnaissance, actors use tools like SoftPerfect, Advanced IP Scanner, and NetScan.
    - Encyrption:  Encrypted files are appended with a .akira or .powerranges extension. 

    Additionally, a ransom note named fn.txt or akira_readme.txt appears in both the root directory (C:)
    and each user’s home directory (C:\Users)

- Log Management

    Im using the LetsDefend log management to check the activity on IP 172.16.17.130. 

    ![alt text](<screenshot/Screenshot 2026-08-25 at 1.39.58 PM.png>)
    
    There's a sequence of activity 

    - Evidece 1 - Zip File Extraction

        ![alt text](<screenshot/Screenshot 2026-08-25 at 1.44.46 PM.png>)

        The command are indicating that the file after being downloaded it is extracted through 7z.

        ![alt text](<screenshot/Screenshot 2026-08-25 at 1.53.01 PM.png>)
        ![alt text](<screenshot/Screenshot 2026-08-25 at 2.25.24 PM.png>)

        After being extracted, the zip file containing 
        Payment Confirmation Invoice #12345.exe.
    
    - Evidence 2 - Anti Virus Trying to Terminate Running Process

        ![alt text](<screenshot/Screenshot 2026-08-25 at 1.49.55 PM.png>)
        ![alt text](<screenshot/Screenshot 2026-08-25 at 1.50.09 PM.png>)

    - Evidence 3 -  Indicated Ransomware Command

        ![alt text](<screenshot/Screenshot 2026-08-25 at 1.55.42 PM.png>)
        ![alt text](<screenshot/Screenshot 2026-08-25 at 2.05.17 PM.png>)

        the command, indicating to remove the shadow copy.
        This is align with ransowmare attack characteristics
    
    - Evidence 4 - Akira_readme.txt

        ![alt text](<screenshot/Screenshot 2026-08-25 at 2.06.44 PM.png>)
        ![alt text](<screenshot/Screenshot 2026-08-25 at 2.13.37 PM.png>)
        ![alt text](<screenshot/Screenshot 2026-08-25 at 2.14.01 PM.png>)
        ![alt text](<screenshot/Screenshot 2026-08-25 at 2.12.10 PM.png>)

        and this is the evidence confirming that the ransomware attack are belong to Akira. Akira_readme.txt is under /users directory.

    - Report 

        Verdict: TRUE POSITIVE

        Report:  At 2024-10-02T05:52:00+03:00 IP 172.16.17.130 with Hostname Vergil receiving an email with attachment "payment-confirmation-invoice-12345.zip". Not long after that IP 172.16.17.130 click and extracting the zip file through 7z and spawning "Payment Confirmation Invoice #12345.exe" at the same time AntiVirus runnign taskkiill.exe process.

        Not long after that sequence, a powershell command with intention to remove the shadow copy are running. This is indicating that the attack is a ransomware.

        After further investigation, a multiple download process happen at the users directory and spawning Akira_readme.txt. This is indicating that this is Akira ransomware.

    - Remediation

        - Containment for IP 172.16.17.130
        - Terminate malicious process
        - Preserve evidence

# Case 3 - Lazarus Phishing

![alt text](<screenshot/Screenshot 2026-08-28 at 8.53.08 AM.png>)

The alert says, Lazarus Phishing Campaign Detected. 

Im starting by collecting IOC from this alert.

- IOC
    - Event Time: 2025-03-06T07:15:00+03:00
    - SMTP Address: 152.89.61.96
    - Source Address: [trevorgreer9312@gmail.com]
    - Destination Address: [Ellen@letsdefend.io]
    - Email Subject: Invitation: Coinbase Crypto Trader Hiring Assessment
    - Senders IP: 172.16.20.3

After that i go to the investigation to find the evidence of phishing. 
but before that i need to know what Lazarus phishing Campaign is.

- Lazarus Phishing 101
    
    Lazarus phishing campaign is a targeted phishing(spear phishing) which conducted by Lazarus Group to gain initial access. The method they often use is fake job offers, trojanized PDF software, and a windows zero-day.

- Investigation

    - Evidence 1 - Fake Job Offers
    
        Email Subject: Invitation: Coinbase Crypto Trader Hiring Assessment

        The email subject is indicating a job offers. This is align with methods that Lazarus group often used.
    
    - Evidence 2 - Online threat intel result on IOC

        Im using VirusTotal and AbuseIPDB to check the SMTP address.

        - VirusTotal Result on IOC.

            ![alt text](<screenshot/Screenshot 2026-08-28 at 9.38.41 AM.png>)

            The result indicating that the SMTP Address are suspicious.

        - AbuseIPDB

            ![alt text](<screenshot/Screenshot 2026-08-28 at 9.40.27 AM.png>)
            ![alt text](<screenshot/Screenshot 2026-08-28 at 9.41.51 AM.png>)

            The confidence of abuse and small reports doesn't meant that the IP is not suspicious.


        Now, im going to inspect the log management and the email to check whether the email is containing suspicious attachment and whether the recipient clicing the attachment.

    - Email Investigation

        ![alt text](<screenshot/Screenshot 2026-08-28 at 9.49.48 AM.png>)

        Here is the full email attachment, and there is more IOC, the sender IP.

        based on this, the senders domain doesn't look suspicious.

        and there's no file attachment on the emaail. But, there's embeded link that directed to hxxps[://]blockchainjobhub[.]com/invite/E3fM8yF7 websites



        The Sender IP are more likely a company email gateway.

    -  Evidence 3 - URL Analysis

        hxxps[://]blockchainjobhub[.]com/invite/E3fM8yF7

        - blockchainjobhub: is a generic crypto recruitment name while the email says it is coinbase which is the offcial brand
        - /invite/E3fM8yF7: Personalised invitation token

        ![alt text](<screenshot/Screenshot 2026-08-28 at 10.31.49 AM.png>)

        Online threat intelligence indicating that the websites are malicious.

    The email are proven to be a phishing email. Now, im investigate whether ellen has been clicking the URL and find evidence of malware running.

    - Evidence 4 - Log Management
        
        ![alt text](<screenshot/Screenshot 2026-08-28 at 10.42.52 AM.png>)

        this is a screenshot of ellen endpoint. Ellen accessing the websites at 2025-03-07 00:21:35.

        im using ellen IP to search the activity during that time windows 

        IP Address: 172.16.17.214

        ![alt text](<screenshot/Screenshot 2026-08-28 at 11.02.18 AM.png>)
        ![alt text](<screenshot/Screenshot 2026-08-28 at 11.04.06 AM.png>)
        ![alt text](<screenshot/Screenshot 2026-08-28 at 10.54.16 AM.png>)
        ![alt text](<screenshot/Screenshot 2026-08-28 at 11.54.24 AM.png>)

        This process are highly suspicious and the commandline directing to malicious websites based on threat intel

        ![alt text](<screenshot/Screenshot 2026-08-28 at 11.27.16 AM.png>)

        but the phishing email is only directed to ellen.

- Report

    Verdict: TRUE POSITIVE

    Report: 

    2025-03-06T07:15:00+03:00 [trevorgreer9312@gmail.com] sending an email with subject "Invitation: Coinbase Crypto Trader Hiring Assessment". The email containing embeded URL that directed to hxxps[://]blockchainjobhub[.]com/invite/E3fM8yF7 with personalied invitation token. Based on Threat Intel URL are malicious and The SMTP address are suspicious. Not long after recipient access the URL, new process created and directed to malicious websites.

- Remediation

    - Containment for IP 172.16.17.214
    - Remove malware, block phishing domain, and malicious download doamin.
    - Terminate process


    

