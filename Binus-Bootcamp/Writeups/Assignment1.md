# Penetration Testing Report
Given the website that set up using docker. 

To run the docker website, im using command "docker compose up -d"
and access it in a localhost that can be found on docker console.
![alt text](<../screenshot/Screenshot 2026-09-25 at 1.56.55 PM.png>)

And the url directed to library of books website.
![alt text](<../screenshot/Screenshot 2026-09-25 at 1.58.47 PM.png>)

For this bootcamp assignment, we need to explore and find the vulnerable of this website.

The attack is conducted with a phase.

# Phase 1: Reconnaissance
The first phase of any penetration testing is reconnaissance.

- Flag 1: Page source analysis -> (HTML comment)

    After directed to the website, im checking the page source.
    and i found the flag as the html comment.
    ![alt text](<../screenshot/Screenshot 2026-09-25 at 2.02.05 PM.png>)
    ![alt text](<../screenshot/Screenshot 2026-09-25 at 2.02.53 PM.png>)

    flag: "MBPTL-1{bf094c0b92d13d593cbff56b3c57ad4d}"

- Flag 2: http header

    To get this informatin im using command "curl -I http://localhost/"

    ![alt text](<../screenshot/Screenshot 2026-09-25 at 2.05.59 PM.png>)

    From the output, we could get the flag.

    flag: "MBPTL-2{10e0daf1aefdfa42ba53f1d03dc3b7da}"

- Flag 3: Port Scanning

    Im using nmap, a network scanning tools to find open ports. 
    To find more details about the ports im using command "nmap -sV -sS -p- localhost"

    Here's the result of the nmap scanning,
    ![alt text](<../screenshot/Screenshot 2026-09-27 at 8.59.47 AM.png>)

    there's port 80 and 8080 opened and when i explore the port 8080 i found this,
    ![alt text](<../screenshot/Screenshot 2026-09-27 at 9.01.41 AM.png>)

    Flag on port 8080: "MBPTL-3{f74dc48447423d67699b233c461227a4}"

# Phase 2: Enumerations

Because this is a website, im thinking of using enumeration tools like gobuster to find hidden directory.

- Flag 4: gobuster directories enumeration report

    After trying to find hidden directories using gobuster as a tools, i found interesting directories. here's the scanning result,
    ![alt text](<../screenshot/Screenshot 2026-09-27 at 9.26.37 AM.png>)

    there's administrator directories that i found and lets try to explore that page.
    ![alt text](<../screenshot/Screenshot 2026-09-27 at 9.29.20 AM.png>)

    It directed to the login page and there's a flag too.

    flag: MBPTL-4{eb75482e45154917d44882e0c4a8e68f}

    ![alt text](<../screenshot/Screenshot 2026-09-27 at 10.59.24 AM.png>)
    And here's the login page source code, the information that i could obtain there is, http method and no message for the wrong passwords.

# Phase 3: SQL Injection

Back to the library website,
![alt text](<../screenshot/Screenshot 2026-09-27 at 11.32.05 AM.png>)
If i click view details, the URL becomes
![alt text](<../screenshot/Screenshot 2026-09-27 at 11.33.17 AM.png>)
"http://localhost/detail.php?id=1"

- Flag 5: SQL Vulnerabilities
    I added special char ['] so the URL become "http://localhost/detail.php?id=1'"

    And here's the page become,
    ![alt text](<../screenshot/Screenshot 2026-09-27 at 11.38.26 AM.png>)

    Flag 5: MBPTL-5{4bcce60b74914398c04eb5b546995408} 

- Flag 6: sqlmap tools

    Using sqlmap tools to see the available db and here's what i found, 

    ![alt text](<../screenshot/Screenshot 2026-09-27 at 12.06.47 PM.png>)

    and i start from administrator db and dump it using sql map to find more information about this.

    ![alt text](<../screenshot/Screenshot 2026-09-27 at 12.08.32 PM.png>)

    and found the flag, 
    Flag 6: "MBPTL-6{9fce407640f5425f688c98039bc67ee6}"

    and also found this interesting credentials,

    ![alt text](<../screenshot/Screenshot 2026-09-27 at 12.09.48 PM.png>)

    Maybe this credentials could be use on the login page that i found before this.

- Flag 7: Admin page

    Using the same credentials that i found from sqlmap dumping tools and here's the page for admin.
    ![alt text](<../screenshot/Screenshot 2026-09-27 at 12.11.28 PM.png>)

    Flag 7: "MBPTL-7{e77ac27271c6e54470db47228b9eca09}"

# Phase 4: Post-Exploitation

On the admin page there's file uploading button for image. This feature could be exploited by uploading malicious script.

before uploading we could analyze what file type that this button accepted for upload.

![alt text](<../screenshot/Screenshot 2026-09-27 at 12.48.12 PM.png>)

The button is only accepting image, but we could delete the line and upload any type of file extension on this button.

- Prepare the file

    The goal is to make the URL become a shell that we could interact with command.

    Script: 
    ![alt text](<../screenshot/Screenshot 2026-09-27 at 12.51.14 PM.png>)

    If we upload this file we could use it as a terminal on the url

- Flag 8: File Upload

    After that, the url could become a terminal
    ![alt text](<../screenshot/Screenshot 2026-09-27 at 1.01.22 PM.png>)

    There's root.txt and user.txt file hidden

    im trying to obtained this user.txt file and here's what i found 
    ![alt text](<../screenshot/Screenshot 2026-09-27 at 1.02.34 PM.png>)

    Flag: "MBPTL-8{e284ebd7a0008f5f3a5ca02cc3e4764b}"

- Flag 9: Post-Exploitation | Root Access

    Using reverse shell method with the same way, by uploding it using upload button on admin page.
    
    and i run linpeas.sh

    ![alt text](<../screenshot/Screenshot 2026-09-27 at 3.17.56 PM.png>)

    Here's the interesting line,
    ![alt text](<../screenshot/Screenshot 2026-09-28 at 2.14.41 PM.png>)
    ![alt text](<../screenshot/Screenshot 2026-09-28 at 2.13.47 PM.png>)
    ![alt text](<../screenshot/Screenshot 2026-09-28 at 2.15.36 PM.png>)
    ![alt text](<../screenshot/Screenshot 2026-09-28 at 2.32.28 PM.png>)
    ![alt text](<../screenshot/Screenshot 2026-09-27 at 3.21.06 PM.png>)

    Flag 9: "MBPTL-9{74ac6fef30abfc98e8532548b9742050}"

# Phase 5: Log Analysis

- Flag 10: Web Access Log Analysis

    After obtaining the root privilege user, im trying to explore more about this machine, and access the log in this directory, 
    
    "/var/log/apache2"
    ![alt text](<../screenshot/Screenshot 2026-09-29 at 8.12.37 AM.png>)
    
    Flag 10: MBPTL-10{c1835d7d28a5394b38cfbf6f813a1553}

- Flag 11: Command History Analysis

    Im checking the command history to obtain the flag. To do this, im going to explore directory on the machine.

    ![alt text](<../screenshot/Screenshot 2026-09-29 at 8.21.08 AM.png>)

    and i manage to go to /root directory and list the file. 
    And here's what i found,
    ![alt text](<../screenshot/Screenshot 2026-09-29 at 8.22.38 AM.png>)

    .bash_history is the file that storing command history on this machine. 

    Using command cat to see the file and i got this,

    ![alt text](<../screenshot/Screenshot 2026-09-29 at 8.24.03 AM.png>)

    Flag 11: MBPTL-11{c2090290b9012cd448129e26626c8cde}

- Flag 12: Shell Configuration Analysis

    Shell configuration are store on .bashrc according to google, 
    ![alt text](<../screenshot/Screenshot 2026-09-29 at 8.28.44 AM.png>)

    And the file that listed on /root

    ![alt text](<../screenshot/Screenshot 2026-09-29 at 8.22.38 AM.png>)

    There's .bashrc file and to see it im using command "cat .bashrc"

    ![alt text](<../screenshot/Screenshot 2026-09-29 at 8.31.13 AM.png>)

    Flag 12: MBPTL-12{a475806f05e0416bcd8cde2d02dfde95}

# Phase 6: Network Pivoting

- Flag 13: Network Pivoting

    