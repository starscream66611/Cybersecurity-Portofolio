# Kerberos and Its Vulnerability

Kerberos is a network security protocol that authenticates service request between two or more trusted networks.

Three head of kerberos:
- Kerberos -> client
- Server
- Key distribution center(KDC)

Function as a third party authentication service.

# How It Works
![alt text](<../screenshot/Screenshot 2026-09-24 at 7.28.28 AM.png>)

# Vulnerability

- Kerberoasting
    
    Abuse of the kerberos mechanism feature. Ticket Granting Server send ticket that encrypted using secret key, which was service account password hashes.

    The attack method for this is to crack the passwords offline using tools such as john the ripper, rubeus, and impacket.

    The attack happened on **service account side**.

    This happened at post-exploitation technique.

    - Requirement: -> main goal to obtained ticket
        - Request service ticket for any service with registered Service Principal Name(SPN).
        - The Success depend on how strong of the password is.

    - Service Principal Name: 
        - www/host1@htb.indo
        - service_class/host@domain

    - 2 Stage to conduct the attack:
        - Stage 1. Collecting the ticket or interact with the with kerberos -> Rubeus and Impacket.
        - Stage 2. Cracking the ticket or passwords -> John the ripper.

    - Tools to obtained the ticket(SPN):
        - Rubeus -> Stage 1
        - Impacket -> Stage 1

    - Mitigation:
        - Strong service passwords
        - Dont make service account domain admins

- AS-REP Roasting

    Start from client authenticate himself to the domain controller, before obtaining TGT.