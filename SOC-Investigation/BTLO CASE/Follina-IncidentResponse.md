# BTLO - Incident Response Investigation — Follina
this labs im getting from blue team labs online

the scenario for this labs is the new RCE vulnerability actively being exploited in the wild. 
and the task is to analyzing and researching the sample to collect the information

so here's the given file:
![alt text](<screenshot/Screenshot 2026-08-15 at 1.41.58 PM.png>)

# 1. unzipping the file and checking the hash.
to investigate this file i need to unzip it and check the has values.

to get the hash values of the file, im using command "sha1sum" on kali terminal.
![alt text](<screenshot/Screenshot 2026-08-15 at 1.45.52 PM.png>)

so the hash values for this file is: 06727ffda60359236a8029e0b3e8a0fd11c23313 (1)

# 2. using the threat intelligence services to get more information.

to get more information about this file im using the online threat intelligence services. im using VirusTotal to check the full file type.

im using the hash values that already been obtained for the threat intelligence.

and here's what i found: 
![alt text](<screenshot/Screenshot 2026-08-15 at 1.51.15 PM.png>)
![alt text](<screenshot/Screenshot 2026-08-15 at 1.54.30 PM.png>)
![alt text](<screenshot/Screenshot 2026-08-15 at 1.55.01 PM.png>)

now, we get more information about this file.
the file is obviously suspicious and containing malware and the full file type for this document are 

"Office Open XML Document" (2)

# 3. examining the embeded URL inside the file
so i need to make a copy of this file, to make sure that the original file are untouch. im using command "cp" on kali to make the copy file.
![alt text](<screenshot/Screenshot 2026-08-15 at 2.02.24 PM.png>)

now we get the copy file, and im trying to check if there is embeded URL inside the file by using command

[strings sample_copy.doc | grep -Eo 'https?://[^"<>]+']

and i cant find anything using that command
![alt text](<screenshot/Screenshot 2026-08-15 at 2.13.30 PM.png>)

so i check the file again to see what it is and here's what i got

![alt text](<screenshot/Screenshot 2026-08-15 at 2.14.01 PM.png>)
so it is a microsoft word document.
it means that this is docx file format eventhough the file extension are .doc

so according to google, docx format is a zip archive in disguise. that means, it contains a collection of text file written in xml.

from that information, im trying to unzipping the file again and see the collection of text file.

the command im using for this is [unzip -l sample_copy.doc]

im using -l to list the collection of file before extracting anything yet.

and here's what i found
![alt text](image.png)

there's a colelction of file listed on sample_copy.doc
and i found a file that using double extension like .xml.rels.

now i need to know what .xml file do and what .rels do

according to google: 
- .xml -> a plain text document that uses custom tags to store and transport data
- .rels -> an internal metadata document in the Open Office XML (OOXML) standard used by Microsoft Office. It maps how different parts of a compressed file package connect together, linking text, media, and formatting.

now, i know that rels is like a map of connection to the external resource. 
i could start to find any embeded URL in there.

im making another directory for the extracted file using command "mkdir", and unzip the doc file into the extracted directory.

the command is : "unzip sample_copy.doc -d extracted"
![alt text](<screenshot/Screenshot 2026-08-15 at 2.39.55 PM.png>)
![alt text](<screenshot/Screenshot 2026-08-15 at 2.41.14 PM.png>)

now the goal is to see that .rels file, so i manage to go to directory word/_rels/document.xml.rels.

and read the file by using command "cat" on terminal.
here's what i found:
![alt text](<screenshot/Screenshot 2026-08-15 at 2.47.07 PM.png>)

we found the embeded URL inside this file 
![alt text](<screenshot/Screenshot 2026-08-15 at 2.49.10 PM.png>)
![alt text](<screenshot/Screenshot 2026-08-15 at 2.50.15 PM.png>)

so the embeded URL that we obtained from this file is 
"hxxps[://]www[.]xmlformats[.]com/office/word/2022/wordprocessingDrawing/RDF842l[.]html!"(3)

and this URL leads to HTML file 

and the document that storing this URL is "document.xml.rels"(4)

# 4. Analyzing HTML files
we already obtained some information like hash value, file type, embeded URL, and document that storing URL.

the URL leads to HTML file. now, i need to know the behavior of the HTML file by looking at the source code.

so im making new directory to analyzing this HTML files using "mkdir" command on terminal.

and using this command to donwload the html files
"curl -L -o RDF8421.html 'URL'"

![alt text](<screenshot/Screenshot 2026-08-15 at 3.11.55 PM.png>)

Limitation :
- the extracted URL pointed to an external HTML file, but the associated domain was no longer resolvable. to maintain the safety of the isolated analysis environment, i did not open the URL directly in a web browser or execute the external resource. the required information was therefore verified through publicly available security research (OSINT) documenting the vulnerability and its exploitation mechanism.

based on publicly available technical analysis of CVE-2022-30190 (Follina), the HTML processing mechanism required the file to be at least 4096 bytes in size for the payload to be invoked. files smaller than 4096 bytes would not trigger the payload.

so the answer is "4096 bytes"(5)
and the process name is "msdt.exe"(6)

so according to goole msdt.exe stands for the Microsoft Support Diagnostic Tool. it is a built-in Windows program designed to run legacy diagnostic and troubleshooting wizards

for this case msdt.exe is used to to kill a process if it is already running

# 5. using open source intelligence to find the behavior of the malware and detection logic.

information that we had now is 

- CVE : CVE-2022-30190
- Vulnerability : Follina
- Malicious Document : Word Document
- Tool : msdt.exe

the task ask me to create process-based detection rule by using Windows Event ID 4688.

Process Behavior : 

- according to microsoft documentation Event ID 4688 is a Security audit log that records when a new program or process is created. It tracks critical details like the process name, creator account, and parent process, making it essential for security monitoring, threat hunting, and tracking system activity
- there's suspicious parent child process included in this attack. the malicious DOC file when opened will spawn the MSDT process. what this would look like in Microsoft Security Audit, event ID 4688 is:
ParentProcessName> C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE and NewProcessName> C:\\Windows\\System32\msdt.exe.
- ParentProcessName = WINWORD.EXE and NewProcessName : msdt.exe

Detection Logic :

IF EventID = 4688

AND NewProcessName = "C:\Windows\System32\msdt.exe"
AND ParentProcessName = "*\WINWORD.EXE"

THEN
    Alert: Possible Follina exploitation

# 6. MITRE ATT&CK
im checking the behavior of this file using online sandbox.
here's what i found
![alt text](<screenshot/Screenshot 2026-08-15 at 4.22.10 PM.png>)

its not completely run because the HTML file that we obtained earlier are no longer in service. but based on OSINT we know the behavior of this malware.

and to get the MITRE ATT&CK id im using the information that we already had.

the important part for me is, this malware created suspicious parent child process start from WINWORD.EXE and msdt.exe.

this behavior is mapped to command and scripting Interpreter — T1059

findings:
- Tactic:     Execution
- Technique:  Command and Scripting Interpreter
- Technique:  T1059

# 7. mitigation for CVE-2022-30190
list of mitigation for CVE-2022-30190:
- Apply patch for CVE-2022-30190 to Windows systems
- Explore applying a workaround provided by Microsoft
- Utilize behavior detection and exploit prevention tools
- Disable support for the MSDT URL protocol
