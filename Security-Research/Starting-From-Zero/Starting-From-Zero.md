# STARTING FROM ZERO

Inspired by a question that been given by the interviewer.

Question: "What would you do if you come to a company and starting the security from zero?"

# Phase 1 - Understand The Environment

First move, im going to do a mapping on every assets that the company had.

Objective: Build a complete inventory of the organization's assets before monitoring or defending the environment.

For the assets im thinking that we could separate this into some different categories.

# Assets Mapping

- Endpoint Assets: 

    - Hostname
    - IP Address
    - Operating System & Version
    - Owner/Deartment
    - Criticality
    - Role & Identities

- Servers:

    - Hostname/Server name
    - Role
    - IP Address
    - Operating System
    - Environment
    - Owner/Team
    - Criticality
    - Ports Open

- Network Devices:

    - Hostname
    - Device Type
    - Vendor / Model
    - Management IP
    - Location
    - Network Segment
    - Remote Management

- Cloud Resources:

    - Cloud Provider
    - Resource Name
    - Resource Type
    - Region
    - Owner / Team
    - Public or Private

# Phase 2 - Security Baseline & Hardening

Objective: Establish a secure baseline across the organization's environment before deploying monitoring tools such as EDR or SIEM.

This phase focuses on reducing the attack surface and ensuring every asset follows the organization's minimum security standards.

- To do:
    - Apply the Principle of Least Privilege (PoLP) to users and administrators.
    - Harden endpoints with security policies and operating system configurations.
    - Harden servers by removing unnecessary services and restricting administrative access.
    - Harden network devices using segmentation and secure management protocols.
    - Apply baseline security controls to cloud resources and identities.

# Identity & Access Hardening

Implement least privileges here

Rule: 
- Remove local administrator privileges from standard users.
- Use separate administrator accounts for privileged tasks.
- Disable inactive or unused accounts.
- Require Multi-Factor Authentication (MFA) for privileged accounts.
- Review group memberships regularly.

# Endpoint Hardening

Endpoint should follow a consistent security baseline.

Baseline Configuration:
- Automatic operating system updates enabled.
- Host firewall enabled.
- Disk encryption enabled (BitLocker/FileVault).
- Strong password and screen lock policy.
- Disable unnecessary services and applications.
- Restrict script execution where appropriate.

# Server Hardening

Servers require stricter controls than employee endpoints.

Baseline Rules:
- Disable unused services and ports.
- Restrict administrative access to trusted networks.
- Keep operating system and applications patched.
- Use secure remote administration methods (SSH/RDP with restrictions).
- Enable backups and recovery policies.

# Network Hardening

Reduce unnecessary network exposure before monitoring traffic.

Baseline rules:
- Segment using VLANs.
- Allow only required inbound and outbound ports.
- Disable insecure management protocols such as Telnet.
- Restrict management interfaces to IT administrators.

# Cloud Security

Cloud environments need their own baseline policies.

Baseline rules:
- Apply IAM least privilege.
- Enable MFA for administrator accounts.
- Block public access to storage by default.
- Encrypt sensitive storage and databases.
- Rotate API keys and secrets regularly.

This phase comes before SIEM/EDR because, hardening reduces the number of a window for an attacker to gain access/advantages. SIEM/EDR is best for monitoring and by mapping the whole environment first, we know exactly what critical, which one to contain, and yeah.

# Phase 3 - Implement Monitoring System.

Objective: Ensure every critical asset produces security telemetry that can be collected, searched, and investigated.

This phase is to implement the monitoring system by combining log collector -> EDR -> SIEM

# Conclusion
These are the first 3 steps to make sure the security if we need to start from zero.