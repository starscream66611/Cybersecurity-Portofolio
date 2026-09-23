# Security Principles - TryHackMe Learning

Main objectives:
- Explain the security functions: Confidentiality, Integrity and Availability (CIA).
- Present the opposite of the security triad, CIA: Disclosure, Alteration, and Destruction/Denial (DAD).
- Introduce the fundamental concepts of security models, such as the Bell-LaPadula model.
- Explain security principles such as Defence-in-Depth, Zero Trust, and Trust but Verify.
- Introduce ISO/IEC 19249.
Explain the difference between Vulnerability, Threat, and Risk.

# CIA Triad

Component of CIA triad is Confidentiality, Integrity,  Availability :
- Confidentiality: ensures that only the intended persons or recipients can access the data.
- Integrity: Ensure that the data or sentive information cannot been altered.
- Availability:  Ensure that the system, apps, data, program can always be access whenever needed.

A step further from CIA triad:
- Authenticity: meaning that the data is not fraudulent or counterfeit. Ensure that the data is obtained from claimed source.
- Nonrepudiation: ensures that the original source cannot deny that they are the source of a particular document/file/data.
- Utility: Usefulness of the information
- Posession: ensure that we protect the information from unauthorized taking, copying, or controlling.

# DAD Triad - Attack
This is the opposite of the security triad.

Component of DAD triad is Disclosure, Alteration, Destruction/Denial
- Disclosure: The opposite of confidentiality, an act to make the secret information known to others.
- Alteration: The opposite of Integrity, an act to make change, edited, altered file or assets.
- Destruction/Denial: The opposite of availabilty, an act to destruct or make the program, apps, system can't be accesed.

# Fundamentals Concept of Security Models

Three foundational security models:

- Bell-LaPadula Model: -> Least Priveleged
    - Simple Security Property: referred to as "no readup". lower security level cannot read an object at a higher security level. To prevent access to sensitive information above the authorized level.
    - Star Security Property: referred to as "no write down". Higher security level cannot write to a lower security level. To prevent disclosure of sensitive information.
    - Discretionary-Security Property: uses an access matrix to allow read and write information.

        Example of Discretionary-Security Property:
        ![alt text](<screenshot/Screenshot 2026-09-23 at 8.00.11 AM.png>)

        d|rwx|r-x|r-x -> DAC Permission 
        - d -> File type
        - 1st[---] -> Owner read, write, execute.
        - 2nd[---] -> Group read and execute.
        - 3rd[---] -> Others read and execute.

- Biba Model

    Biba model aims to achieve integrity with two main rules:

    - Simple Integrity Property: referred as "no read down", higher integrity subject should not read from lower integrity object.
    - Star Integrity Property: referred to as "no write up". Lower integrity subject should not write to a higher integrity object

- Clark-Wilson Model

    aims to achieve integrity by using the concept:
    - Constrained Data Item (CDI): refers to data type whose itegrity we want to preserve. Meaning,  data that is protected and can only be modified through authorized procedures.
    - Unconstrained Data Item (UDI): refers to all data types beyond CDI, such as user and system input.
    - Transformation Procedures (TPs): procedures are programmed operations, such read and write, and should maintain the integrity of CDI's
    - Integrity Verification Procedures (IVPs): These procedures check and ensures the validity of CDIs.

# Defence in Depth

Creating a multiple level of security system.

- ISO/IEC 19249 Five Architectural Principles:
    - Domain Separation: Every set of related group components is grouped as single entity; Component can be applications, data, or other sources and each entity will be assigned to its own domain and assigned a common set of security attributes.
    - Layering: a system is structured into many abstract levels or layers.
    - Encapsulation: In object oriented programming(OOP) hide low level implementation and prevent direct manipulation in an object by providing specific methods
    - Redundancy: ensures availabilty and integrity. Applied a proper backup system.
    - Virtualization: sharing a single set of hardware among multiple operating sytem. Virtualization provides sandboxing capabilities that improve security boundaries, secure detonation, and observance of malicious programs.

- ISO/IEC 19249 Five Architectural Principles:
    - Least Privilege: provide the least amount of permission for someone to carry out their task and nothing more. For example, if a user needs to be able to view a document, you should give them read rights without write rights.
    - Attack Surface Minimisation: These vulnerabilities represent risks that we should aim to minimize. For example, to harden linux system, disable any service we dont need.
    - Centralized paramater validation: the validation of the parameters should be centralized within one library.
    - Centralized General Security Services: we should aim to centralize all security services. For example, we would create a centralized server for authentication. Of course, you might take proper measures to ensure availability and prevent creating a single point of failure.
    - Preparing for error and Exception handling: design a system to have the fail safe. for example, if a firewall crashes, it should block all traffic instead of allowing all traffic. Moreover, we should be careful that error messages don’t leak information that we consider confidential, such as dumping memory content that contains information related to other customers.
    