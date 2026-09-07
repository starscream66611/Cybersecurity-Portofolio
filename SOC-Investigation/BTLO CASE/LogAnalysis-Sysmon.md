# Sysmon - Log Analysis - Blue Teams Labs Online

![alt text](<screenshot/Screenshot 2026-09-07 at 9.08.39 AM.png>)

the goal here is to analyse log and obtain much information.

Im using Splunk run in my docker Cyber security lab to analyze the log that been given

![alt text](<screenshot/Screenshot 2026-09-07 at 9.11.24 AM.png>)

There is 1,484 events on this log.

# Investigation

- What is the file that gave access to the attacker?

    To find this im gonna start by seaching suspicious file or execution file.

    Query: 
    index=sysmon System.EventID=11 | table _time EventData.Image EventData.TargetFilename | sort - _time

    and here's the search become.
    ![alt text](<screenshot/Screenshot 2026-09-07 at 9.19.04 AM.png>)

    While investigating i find this events suspicious.
    ![alt text](<screenshot/Screenshot 2026-09-07 at 9.57.26 AM.png>)

    The reason is, it starting from downloads folder nad spawning udpater.hta file. After that, there is .ps1 file which is powershell.

    So, the first entry of attack is Downloads -> .tmp file -> updater.hta->powershell

    the answer is udpater.hta

    the .tmp file is a temporary file created by the operating system while permanent file is being processed.

    What is the file that gave access to the attacker?
    = updater.hta

- What is the powershell cmdlet used to download the malware file and what is the port?

    To find what powershell cmdlet im change the event id to new process which is 1.

    so the command would be, 

    index=sysmon System.EventID=1 
    | table _time EventData.Image EventData.TargetFileName  EventData.CommandLine
    | sort - _times

    I start investigating by checking what happens after updater.hta
    ![alt text](<screenshot/Screenshot 2026-09-07 at 11.09.38 AM.png>)
    the command -nop -w hidden is highly suspicious because it indicate a stealthy execution. After that, i investigate the following events related to powershell.

    here's what i found.
    ![alt text](<screenshot/Screenshot 2026-09-07 at 11.09.03 AM.png>)

    There's another stealth execution and also INvoke-WebRequest.

    INvoke-WebReqeust is powershell cmdlet used to send HTTP, HTTPS, FTP, and FILE request to web server or API. In this case, cmdlet is used to download the malware file.

    What is the powershell cmdlet used to download the malware file and what is the port?

    The answer is INvoke-WebRequest on port 6969

- What is the name of the environment variable set by the attacker? 

    after the cmdlet there's cmd command use.
    ![alt text](<screenshot/Screenshot 2026-09-07 at 11.40.53 AM.png>)

    cmd /c set compsec=C:\windows\temp\supply.exe

    this command is used to create or modify environment variables.

    What is the name of the environment variable set by the attacker? 
    compsec=C:\windows\temp\supply.exe

- What is the process used as a LOLBIN to execute malicious commands? 

    now that i know the command is downloaded adn environment set. Im going to see what happen next to find the answer.

    LOLBIN(living of the land binary) attacker could abuse this binary to execute malicious commands or payloads.
    ![alt text](<screenshot/Screenshot 2026-09-07 at 12.11.20 PM.png>)
    After the enivronment set, it moves to ftp and after that there's a lot of ipconfig command.

    powershell.exe is could be used because the malicious activity starting from there. But, the weird activity after ftp.exe could indicate that the execution starting from there.  

    What is the process used as a LOLBIN to execute malicious commands?  ftp.exe
- Malware executed multiple same commands at a time, what is the first command executed?

    ![alt text](<screenshot/Screenshot 2026-09-07 at 12.11.20 PM.png>)
    ![alt text](<screenshot/Screenshot 2026-09-07 at 12.17.35 PM.png>)

    After ftp.exe, the command is ipconfig with a suspicious numbers of acticity.

- Looking at the dependency events around the malware, can you able to figure out the language, the malware is written

    ![alt text](<screenshot/Screenshot 2026-09-07 at 9.19.04 AM.png>)

    On this screenshot supply.exe creating file python27.dll

    the answer for this is python

- Malware then downloads a new file, find out the full url of the file download 

    After many commands starting from the ipconfig it also try another command like,
    ![alt text](<screenshot/Screenshot 2026-09-07 at 12.43.07 PM.png>)


    the activity after these commands are 
    ![alt text](<screenshot/Screenshot 2026-09-07 at 12.44.28 PM.png>)

    there's another cmdlet command is used to download the file juicypotato.exe on github.

    this is the answer for the question hxxps
    [://]github[.]com/ohpe/juicy-potato/releases/download/v0[.]1/JuicyPotato[.]exe

- What is the port the attacker attempts to get reverse shell? 

    To investigate this, im going to check the activity after downloading a file.

    and here's i found suspicious command 
    ![alt text](<screenshot/Screenshot 2026-09-07 at 12.48.08 PM.png>)

    this command are a pattern of reverse shell attempt for IP 192.168.1.11 on port 9898.

    the answer is 9898