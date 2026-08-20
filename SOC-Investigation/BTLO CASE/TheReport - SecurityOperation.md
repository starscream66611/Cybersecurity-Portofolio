# The Report - Blue Teams Labs Online

BTLO has given me the zip file for this task and my job is to study a threat report released in 2022 and suggest some useful outcomes for your SOC.

there's 10 questions that i need to answer and this is the documentation to complete the task.

for this task im using Kali Linux runs in a virtual machine.

# 1. CHECKING THE FILE 
BTLO sometimes given the malicious file. so, as precautions im trying to see what files inside the zip without unzipping it using command [unzip -l filename.zip] on terminal.

![alt text](<screenshot/Screenshot 2026-08-18 at 2.51.20 PM.png>)

and inside the .zip file there is a threat detection report pdf. so this zip file is not containing any malware and it is safe.

now im going to study this report to answer all BTLO questions.

# 2. STUDY THE REPORT
studying the report is needed to answering the BTLO questions

1. Name the supply chain attack related to Java logging library in the end of 2021

so a supply chain compromise occurs when an adversary compromises a software developer, hardware manufacturer, or service provider and uses that access to target customers who
use the affected software, hardware, or service.

in other words, supply chain attack is when attacker compromises a trusted third party that the target depends on.

Attacker -> Supplier/Third party -> Victim

and after reading the threat report, the answer for that question is "log4j"(1) 

![alt text](<screenshot/Screenshot 2026-08-18 at 3.27.27 PM.png>)

log4j could be used for coinminers. 

coinminers is a program or malware that use computer resources to mine cryptocurrency. usually without user permissions.

coinminers attacks can cause : 
- high CPU/GPU usage
- increased system temperature
- faster battery drain
- higher electricity consumption
- slower computer performance
- network connection to mining pools

2. Mention the MITRE Technique ID which effected more than 50% of the customers

from the threat report, technique that effected more than 50% of the customers are command and scripting interpreter.

on MITRE this technique represented with ID "T1059"(2)

# Command and Scripting Interpreter(T1059)
attacker can abused a built it command line and scripting environments to execute a malicious commands, script, or binaries on a compromised system.

examples:
- Unix Shell -> Linux or macOS
- Windows Command Shell -> cmd.exe
- PowerShell -> windows scripting and automation environment

why it matters:  suspicious command execution can be an important indicator of compromise, especially when commands are executed by unusual users, processes, or parent applications.

3. Submit the names of 2 vulnerabilities belonging to Exchange Servers

from the documentation, 2 vulnerabilites belonging to exchange server is 

# proxyLogon(CVE-2021-26855, CVE-2021-26857, CVE-2021-26858, CVE-2021-27065)

ProxyLogon is a name used for a set of vulnerabilities affecting Microsoft Exchange Server. It became especially notorious because attackers could exploit vulnerable Exchange servers remotely and, in some cases, gain access to mailboxes or execute code on the server.

Microsoft Exhchange flow:
Internet -> Microsoft Exchange Server -> Company Email

ProxyLogon refers primarily to vulnerabilities that allowed an attacker to bypass authentication and interact with privileged Exchange functionality.

the attack concept of proxyLogon vulnerability:
Attacker -> Internet-facing Exchange Server -> Exploit ProxyLogon vulnerability -> Bypass / obtain privileged access -> Write malicious files -> Execute code -> Compromised Exchange Server

- What to look when investigating an exchange compromise:
    - Suspicious requests to Exchange endpoints
    - Unexpected .aspx files / web shells
    - Unusual Exchange server processes
    - Suspicious PowerShell activity
    - New or modified files
    - Unexpected outbound connections
    - Abnormal mailbox activity   

- Remediation: Apply Microsoft's security updates for the affected Exchange Server versions. Organizations should also investigate vulnerable servers for signs of prior exploitation, remove any identified web shells or persistence mechanisms, reset potentially compromised credentials, and implement network controls to minimize unnecessary exposure of Exchange services.

# ProxyShell (CVE-2021-31207, CVE-2021-34523, CVE-2021-34473)

ProxyShell refers to a chain of three Microsoft Exchange Server vulnerabilities disclosed in 2021:
- CVE-2021-34473 — pre-authentication path confusion vulnerability
- CVE-2021-34523 — elevation of privilege vulnerability
- CVE-2021-31207 — post-authentication remote code execution vulnerability

when it chained together, they could allow an attacker to go from unauthenticated remote access → privileged Exchange functionality → remote code execution on a vulnerable Exchange server.

so, for this two vulnerabilities evidence that we need to gather is: 

- Exchange/IIS logs
    - Unusual HTTP requests
    - Suspicious Exchange endpoints
    - Requests from unexpected external IPs
    - Repeated requests/errors
    - Strange User-Agent strings
    - Requests occurring at unusual times

- Files
    - .aspx
    - .ashx
    - .dll
    - .ps1

- Process Activity
    - w3wp.exe -> cmd.exe -> powershell.exe

- PowerShell
    - Exchange/IIS -> w3wp.exe -> powershell.exe -> Download/Execute paylod

- Network Activity
    - Exchange server connecting to unusual external IPs
    - Connections to suspicious domains
    - C2 traffic
    - Unexpected outbound connections after exploitation

- Persistance
    - Scheduled tasks
    - Services
    - Startup mechanisms
    - New accounts
    - Registry modifications
    - Web shells  

- Workflow to Investigate Mail Exchange Vulnerabilities
    - Vulnerability → Exploitation → Execution → Persistence → C2 / Lateral Movement → Impact

4. Submit the CVE of the zero day vulnerability of a driver which led to RCE and gain SYSTEM privileges 

im back to studying the threat report to answer this questions.

![alt text](<screenshot/Screenshot 2026-08-18 at 4.43.34 PM.png>)

so the answer to that question is "PrintNightmare(CVE-2021-34527)"(4)

# PrintNightmare(CVE-2021-34527)

- PrintNightmare is a Windows Print Spooler vulnerability that can allow an attacker to achieve remote code execution or local privilege escalation, depending on the specific exploitation scenario.

    - CVE: CVE-2021-34527
    - Affected component: Windows Print Spooler
    - Main impact: RCE / privilege escalation
    - Year: 2021

    The Print Spooler is the Windows service responsible for managing printing jobs and related printer functionality.

    ! PrintNightmare = vulnerable Windows Print Spooler → attacker can potentially execute code with high privileges.


- how it abused ??

    An attacker can abuse the Print Spooler functionality to manipulate how printer drivers are handled, potentially causing malicious code to be loaded/executed.

    - Attack flow:
    Attacker -> Abuses Print Spooler vulnerability -> Malicious printer driver / code -> Code execution -> High privileges

- what to check regarding this attack
    - Windows Print Spooler activity
    - Suspicious printer-driver installation
    - Unexpected DLL files
    - spoolsv.exe
    - Suspicious child processes
    - Privilege escalation
    - Network activity involving the affected host

    example = spoolv.exe -> suspicious DLL -> cmd.exe/powershell.exe

5. Mention the 2 adversary groups that leverage SEO to gain initial access

!SEO -> Search Engine Optimization

![alt text](<screenshot/Screenshot 2026-08-18 at 5.41.49 PM.png>)


6. In the detection rule, what should be mentioned as parent process if we are looking for execution of malicious js files 

the answer for this question is "wscript.exe"(6)

# Malicious JavaScript File Execution

Attackers can use Windows Script Host to execute malicious JavaScript files. The primary script interpreters involved are wscript.exe and cscript.exe.

A detection rule should monitor for these processes executing .js files and examine their parent process for suspicious process chains.

flow:
- Parent Process → wscript.exe / cscript.exe → malicious.js

but, wscript.exe / cscript.exe are the process that executing the malicious javascript. the actual parent could be explorer.exe, cmd.exe, powershell.exe, winword.exe, etc.

- what to look??

    - wscript.exe or cscript.exe
    - Command line containing .js
    - Suspicious parent processes
    - Unusual script locations, such as %TEMP% or user download directories
    - Child processes spawned by the script interpreter


7. Ransomware gangs started using affiliate model to gain initial access. Name the precursors used by affiliates of Conti ransomware group

![alt text](<screenshot/Screenshot 2026-08-18 at 6.15.40 PM.png>)

from this table, we could see that the precursors that conti ransomware group are "Qbot, Bazar, IceID"(7)

so,  Qbot, Bazar, IceID are malware families that have been used as initial-access loaders, and some affiliates associated with conti used them to gain access before deploying ransomware.

# QakBot/Qbot

Started as a banking trojan but evolved into a modular malware and initial-access tool.

commonly used to:
- Establish an initial foothold
- Steal credentials
- Download additional payloads
- Collect information
- Enable further intrusion

! QakBot can be the thing that gets the attacker inside before the ransomware stage.

# Bazar / BazarLoader

malware associated with the TrickBot/Conti ecosystem and was used primarily as an initial-access loader.

the flow usually: 
- Victim -> BazarLoader -> Establish foothold -> Download/deploy additional tools -> Hands access to other operators -> Ransomware

# IceID
another malware family that began primarily as a banking trojan and later became heavily used as an initial-access malware/loader.

- Provide attacker with: 
    - Credential theft
    - Information collection
    - Malware delivery
    - Initial access for subsequent operations

! QakBot, BazarLoader, and IcedID = malware/initial-access tools that could provide the foothold for ransomware operations, including activity associated with the broader Conti ecosystem.

8. The main target of coin miners was outdated software. Mention the 2 outdated software mentioned in the report 

![alt text](<screenshot/Screenshot 2026-08-18 at 6.29.22 PM.png>)

so the answer for that is "Jboss, WebLogic"(8)

9. Name the ransomware group which threatened to conduct DDoS if they didn't pay ransom

# Denial of Service Attack
- DoS(Denial of Service) = one/few sources overwhelming a service
- DDoS(Distributed Denial of Service) = many distributed sources overwhelming a service

![alt text](<screenshot/Screenshot 2026-08-18 at 6.34.55 PM.png>)

based on threat report "Fancy Lazarus"(9) threatening to conduct a distributed denial of service intrusion if they didn't pay.

10. What is the security measure we need to enable for RDP connections in order to safeguard from ransomware attacks?

![alt text](<screenshot/Screenshot 2026-08-18 at 6.37.39 PM.png>)

Multi Factor Authentication needs to be enable for Remote Desktop Protocol connection in order to be a safegurads drom ransomware attacks.