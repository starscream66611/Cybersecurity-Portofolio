# Snapped Phishing Line - TryHackMe

Phishing Email Investigation

now we investigate series of an email and see which one is the one.

![alt text](<screenshot/Screenshot 2026-08-03 at 12.20.21 PM.png>)

1. Which individual received the email regarding a Quote for Services Rendered?

    ![alt text](<screenshot/Screenshot 2026-08-03 at 12.22.45 PM.png>)

    looking at the headers, we could see William McClean is the one receiving email.

2. What email address was used by the adversary to send the phishing emails?

    check the from section on the email header and i found Accounts.Payable@groupmarketingonline.icu is the sender.

3. Investigate the attachment in the email addressed to Zoe Duncan.
What is the root domain of the redirection URL found within the file?

    ![alt text](<screenshot/Screenshot 2026-08-03 at 12.34.12 PM.png>)

    ![alt text](<screenshot/Screenshot 2026-08-03 at 12.33.11 PM.png>)

    we found that the root domains of the attachment file is kennaroads.buzz

![alt text](<screenshot/Screenshot 2026-08-03 at 12.35.22 PM.png>)

looking at the screenshot, we found that it impersonating microsoft login page.

we could check it further by navigating to /data directory

![alt text](<screenshot/Screenshot 2026-08-03 at 12.37.57 PM.png>)

we found that there's file exposed in there

4. Navigate to the /data directory.
What is the name of the archive file?

    the answer is Update365.zip

i download the file and trying to obtain the hash values and then check the values to the online tools to gather more information about the file. 

![alt text](<screenshot/Screenshot 2026-08-03 at 12.49.01 PM.png>)
we could see the hash values of the file

5. Using the sha256sum command, what is the SHA256 hash of the file?

    the answer is ba3c15267393419eb08c7b2652b8b6b39b406ef300ae8a18fee4d16b19ac9686

check the hash values to virustotal and here's what i found :
![alt text](<screenshot/Screenshot 2026-08-03 at 12.51.13 PM.png>)

we could see that the file is in zip and it is flagged as malicious on virustotal.

we could information that aside from phishing, the category indicates it's also trojan threat.

6. Aside from phishing, what other threat category is assigned to the ZIP archive?

    the answer is trojan

now, we could check the details of the file in virustotal
![alt text](<screenshot/Screenshot 2026-08-03 at 12.57.15 PM.png>)

we can see that the file contained various data.

7. How many files are contained within the archive?
    
    there is 49 total data contained within the archive


now we go to /Update365/ directory from the email attachment file 
![alt text](<screenshot/Screenshot 2026-08-03 at 1.00.40 PM.png>)

we could find that there's some data that we could investigate.

to answer the next question i click the log.txt to get more information about the activity
![alt text](<screenshot/Screenshot 2026-08-03 at 1.02.28 PM.png>)
now we could seethe credentials of another user that submit it through this phishing attachment

8. What is the email address of the user who submitted their credentials more than once?

    from the log,  we found that michael.ascot@swiftspend.finance submitted the credentials more than once.

now we investigate more about the file that we download from /data directory, by extracting it and here's what i found

![alt text](<screenshot/Screenshot 2026-08-03 at 1.07.56 PM.png>)

i clicked the submit.php file and doing further investigation.
![alt text](image.png)
![alt text](<screenshot/Screenshot 2026-08-03 at 1.15.36 PM.png>)
the screenshot above showing m3npat@yandex.com is the email used to compromised credentials
![alt text](<screenshot/Screenshot 2026-08-03 at 1.10.34 PM.png>)
by looking at the code, we know that user will be redirect to error page no matter if the credentials is right.

9. What email address is used by the adversary to collect compromised credentials?

    email to collect credentials is m3npat@yandex.com

now we need to find the flag for this exercise. 

step.1 find where the flag.txt file located.

here's my starting point to find the flag.txt file.

![alt text](<screenshot/Screenshot 2026-08-03 at 1.32.50 PM.png>)

and i cant find anything on it. 

step.2 going backwards im gonna do what the hint says.
the hint says i need to go to the /Office365 directory
![alt text](<screenshot/Screenshot 2026-08-03 at 1.43.12 PM.png>)
and still can't find anything in it.

because i know that the file that i need to obtain called flag.txt. im just gonna search it right away by adding "flag.txt" on the URL.
so the URL will look like this : 
http://kennaroads.buzz/data/Update365/office365/flag.txt
![alt text](<screenshot/Screenshot 2026-08-03 at 1.47.15 PM.png>)
and i got the txt file containing base64

now im gonna try to decode this base 64 using cyberchef tools.
![alt text](<screenshot/Screenshot 2026-08-03 at 1.48.34 PM.png>)

we found the flag THM{pL4y_w1Th_tH3_URL}

10. Using CyberChef (opens in new tab) to decode the flag, what is the secret value?

the flag is THM{pL4y_w1Th_tH3_URL}