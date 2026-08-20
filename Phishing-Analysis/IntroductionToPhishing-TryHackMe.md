# Introduction To Phishing

this is TryHackMe based practice for introduction to phishing and using Splunk.

# Important Context
Company Information
The Try Daily is a bold, energetic publication dedicated to the art of trying—every single day. Whether it’s testing new ideas, embracing challenges, or stepping outside your comfort zone, we believe that growth comes from action. Our stories, challenges, and expert insights inspire readers to take on something new. We celebrate both success and failure, because every attempt brings you closer to something great.

![alt text](<screenshot/Screenshot 2026-08-04 at 12.16.27 AM.png>)

# Case 1

![alt text](<screenshot/Screenshot 2026-08-04 at 12.17.11 AM.png>)

so the alert is about phishing, i start gather information about the sender, recipient, subject, and content of the email.

we could see, that the sender is onboarding@hrconnex.thm
and the recipient is j.garcia@thetrydaily.thm

by looking at the subject we could see that the message is urgent "Action Required: Finalize Your Onboarding Profile"

before i jump to any online tools to investigate this, lets see the company documentation to find the context of the message.

after that i found that the recipient is from content department and there's no content related from the content of the email.

but now i know that its and onboarding email, so im back looking at the documentation to see whether the sender email is listed there.

![alt text](<screenshot/Screenshot 2026-08-04 at 12.25.12 AM.png>)

the sender email is not listed on the company documentation. 

let's try using online tools :
1. im using WHOIS to check the domain.
![alt text](<screenshot/Screenshot 2026-08-04 at 12.34.46 AM.png>)
can't find anything on whois

2. let's try SPF record and DMARC record 
![alt text](<screenshot/Screenshot 2026-08-04 at 12.36.09 AM.png>)
![alt text](<screenshot/Screenshot 2026-08-04 at 12.36.45 AM.png>)

and still can't find anything with the domain.

3. let's try to check SIEM tool, im using Splunk. the goal in this phase is to get more information.
![alt text](<screenshot/Screenshot 2026-08-04 at 12.39.35 AM.png>)

i start from searching the recipient to see whether she getting another email regarding this.
![alt text](<screenshot/Screenshot 2026-08-04 at 12.42.11 AM.png>)
![alt text](<screenshot/Screenshot 2026-08-04 at 12.42.35 AM.png>)

j. garcia receive more than one email from the same sender. and we could find the host IP.

host IP: 10.10.18.208 
port: 8989

now im checking the host IP with online tools whois

![alt text](<screenshot/Screenshot 2026-08-04 at 12.46.15 AM.png>)

and everything seems normal. nothing really suspicious about that.

so, we get information that the sender domain match the embeded URLs.
![alt text](<screenshot/Screenshot 2026-08-04 at 12.48.17 AM.png>)

by looking at the URLs https://hrconnex.thm/onboarding/15400654060/j.garcia
it's not directed to login page or payment page, where attacker usually trying to get credentials.

so the evidence for this case:

1. urgency subject
2. sender domain and embeded URLs int the content is matched
3. URL is not directed to login page, payment page, downloading anything
4. host IP is legit and normal

so it is a false positive

# Case 2
![alt text](<screenshot/Screenshot 2026-08-04 at 1.00.41 AM.png>)

subject is using urgency message "Action Required"

the sender is urgent@amazon.biz
and the recipient is h.harris@thetrydaily.thm for human resource department.

no attachment on the email. but there is embeded URLs.


lets start by checking the sender domain using online tools :
1. whois 
![alt text](<screenshot/Screenshot 2026-08-04 at 1.04.10 AM.png>)

2. SPF record
![alt text](<screenshot/Screenshot 2026-08-04 at 1.04.39 AM.png>)

3. DMARC record
![alt text](<screenshot/Screenshot 2026-08-04 at 1.05.25 AM.png>)

this information alone can't really determine whether the domain is suspicious or not. we need further investigation

im using Splunk to gather more information.
![alt text](<screenshot/Screenshot 2026-08-04 at 1.11.29 AM.png>)

from this i cant really determine whether the email is suspicious or not. 

so let's see the embeded URLs http://bit.ly/3sHkX3da12340

this link is kind of suspicious: 
1. its using URL shortener bit.ly and URL shortener is hiding the real destination.
2. when i click the link the page is like this
![alt text](<screenshot/Screenshot 2026-08-04 at 1.16.54 AM.png>)

it indicate that this URL is not available because it was created by a suspended account.

so the conclusion is false positive.

evidence : 
1. the online tools to checking sender domain is normal.
2. SPF record and DMARC record seems legit.
3. Splunk indicate that is normal
4. the link shortener is supicious but it is blocked by bitly because of policy.

# Case 3

![alt text](<screenshot/Screenshot 2026-08-04 at 1.29.10 AM.png>)

information that i could get from this case is the sourceIP : 10.20.2.17 
(this IP belongs to hannah harris from HR department)

destination IP: 67.199.248.11
port: 80 -> this is http port.

URL is http://bit.ly/3sHkX3da12340
which is the link that we investigate before.

so hannah harris is clicking the embeded URL then it's blocked by the firewall. but, we need to further investigation for this event.

im starting with online tools: 
- whois the Destination IP and here's what i get
![alt text](<screenshot/Screenshot 2026-08-04 at 1.35.26 AM.png>)
so the IP belongs to bitly.

now im going to Splunk to check this event:
- im using this query * SourceIP="10.20.2.17" to check everything that is happening with the sourceIP.
![alt text](<screenshot/Screenshot 2026-08-04 at 1.39.59 AM.png>)
it looks clean and no other stuff happening.
- im trying this query to DestinationIP="67.199.248.11"
![alt text](<screenshot/Screenshot 2026-08-04 at 1.42.15 AM.png>)
and still looks clean.

conclusion:
so hannah harris is clicking the embeded URL on the email and the action is blocked right away by firewall. the URL shortening is suspicious because it's hiding the real destination. but there's no evidence that indicate this is malicious. but for me, it need a further investigation.

so verdict is true positive.

# case 4

![alt text](<screenshot/Screenshot 2026-08-04 at 1.55.07 AM.png>)

information gathering :
- subject : Unusual Sign-In Activity on Your Microsoft Account. this subject is using urgency wording [suspicious]
- sender : no-reply@m1crosoftsupport.co. it's using typosquatting on the domain name. [suspicious]
- recipient : c.allen@thetrydaily.thm from Web Development department.
- no atttachment on the email
- content : is using embeded link that directed to login page.

now we start the investigation : 
- using virustotal to check the sender domain.
![alt text](<screenshot/Screenshot 2026-08-04 at 2.01.12 AM.png>)
it's not flagged on this website
- im using tools called who is to check the IP address on the content 
![alt text](<screenshot/Screenshot 2026-08-04 at 2.03.11 AM.png>)
- SPF and DMARC record is not existed 

i try using Splunk to gather more information
![alt text](<screenshot/Screenshot 2026-08-04 at 2.09.02 AM.png>)
![alt text](<screenshot/Screenshot 2026-08-04 at 2.09.56 AM.png>)

the SIEM is clean and no other action is happening.

next step im checking the content of the email
![alt text](<screenshot/Screenshot 2026-08-04 at 2.12.32 AM.png>)

the embeded URL is using typosquatting which is highly suspicious for a legit brand to do this and its directed to login page. this is phishing that intender to steal user credentials.

conclusion is true positive.

evidence :
- typosquatting on domain name.
- the embeded URL is directed to login page
- using urgency subject

so this email is highly suspicious and needed more investigation.