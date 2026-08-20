# XSS SCRIPTING BY TYPE AND EXAMPLE

- Reflected XSS

Malicious input is reflected immediately in the server's response. The behavior of this script are Victim clicks a crafted link/request.

erase the (.)

example of script = "<s.cript>alert("Succ3ssful XSS")</s.cript>"

- Stored XSS

Malicious script is saved on the server/database and executed whenever victims view the affected content. Malicious comment stored in a website's database.

more example of this is, imagine a website has a comment box and the eattacker submits a xss script. if the website stores that comment in its database without properly sanitizing/encoding it, the database now contains the malicious HTML.

its called "Stored" 

Because the payload is stored on the server before it reaches the victim.

Attacker submits payload → Server stores it → Victim views it → XSS executes

- DOM-based XSS

The vulnerability happens in the browser's JavaScript/DOM, without necessarily sending the payload to the server. JavaScript takes data from the URL and inserts it into the page unsafely