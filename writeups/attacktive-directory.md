Penetration Test Report – Attacktive Directory Environment

Client: Internal Assessment (TryHackMe – Attacktive Directory)
Assessment Type: Active Directory Penetration Test
Date: 07-12-2025
Tester: Shubh

1. Executive Summary

A penetration test was conducted against the Attacktive Directory Windows domain environment with the objective of evaluating Active Directory security posture, credential hygiene, and domain privilege escalation risks. During the assessment, multiple weaknesses were identified, including weak Kerberos configurations, exposed service accounts, and improper privilege delegation.

Through a combination of Kerberos-based attacks and SMB enumeration, full domain compromise was achieved. The tester successfully escalated privileges to Domain Administrator and extracted password hashes of all domain users via a DCSync attack.

The environment demonstrates several high-risk misconfigurations commonly observed in real-world enterprise Windows domains.

2. Assessment Scope

Target Host: AttacktiveDirectory.spookysec.local

Domain: spookysec.local

Services: LDAP, Kerberos, SMB, RDP, WinRM

Objective:

Enumerate domain users

Identify credential exposure

Attempt privilege escalation

Assess the feasibility of domain compromise

3. Methodology

The engagement followed a standard Active Directory attack chain:

Network Enumeration

SMB/LDAP/Kerberos Enumeration

User Enumeration (Kerbrute)

AS-REP Roasting

Password Cracking

Kerberoasting (SPN extraction)

Credential reuse & lateral movement

Privilege Escalation to Domain Admin

DCSync & NTDS.DIT extraction

This approach mirrors real-world internal threat actor behavior.

4. Key Findings
4.1 AS-REP Roasting Vulnerability

Severity: High
Description:
The service account svc-admin was configured with “Do not require Kerberos preauthentication”, allowing an attacker to request an encrypted AS-REP message without knowing its password.

Impact:
Password hash retrieved → cracked → initial access achieved.

Evidence:

GetNPUsers.py returned valid AS-REP hash for svc-admin.

4.2 Weak Password Policy

Severity: High
Description:
Cracked service account password was simple and easily guessable using a common wordlist.

Impact:
Enabled attacker to authenticate to domain services and access privileged resources.

4.3 Kerberoastable Service Accounts

Severity: High
Description:
Service accounts with Service Principal Names (SPNs) were enumerated and ticket-granting service tickets (TGS) were successfully requested.

Impact:
Potential for offline password cracking of high-privilege accounts.

Evidence:

GetUserSPNs.py returned crackable Kerberos hashes.

4.4 Excessive Privileges Assigned to Service Accounts

Severity: Critical
Description:
svc-admin was discovered to have domain replication privileges, allowing it to perform DCSync operations.

Impact:
Complete extraction of domain password hashes.

Evidence:

secretsdump.py successfully performed DCSync.

4.5 Full Domain Compromise

Severity: Critical
Description:
Using the credentials obtained, the tester escalated to Domain Administrator and accessed sensitive files.

Evidence:

NTDS.DIT password hashes extracted

Administrator-level shell access obtained

5. Attack Path Summary

Below is a simplified attack chain demonstrating how compromise occurred:

Kerbrute enumeration → harvested valid usernames

AS-REP roasting on svc-admin → obtained hash

Password cracked → domain login achieved

SPN enumeration → additional creds discovered

svc-admin had replication rights → DCSync attack

Extracted all domain user & administrator hashes

Complete domain takeover

This represents a realistic, multi-step AD compromise.

6. Recommendations
6.1 Enforce Strong Password Policies

Ensure service accounts use complex passwords

Prevent use of dictionary or common words

Enforce periodic password rotation

6.2 Disable “Do Not Require Preauthentication”

Remove this setting from all accounts

Audit for similar misconfigurations across the domain

6.3 Implement Least Privilege for Service Accounts

Remove unnecessary domain replication rights

Service accounts should not have administrative permissions unless required

6.4 Enable Kerberos AES Encryption

Prevent downgrade to weak RC4 encryption

Enforce AES256 for Kerberos

6.5 Monitor for Kerberos Abuse

Detect high volumes of AS-REQ / TGS-REQ

Enable logging for event IDs related to Kerberos anomalies

6.6 Disable SMBv1 and Harden SMB

Limit anonymous enumeration

Enforce signing where practical

7. Conclusion

The environment is vulnerable to well-known and widely exploited Active Directory attack techniques. A low-privilege attacker was able to escalate to full domain compromise due to multiple misconfigurations involving Kerberos, service accounts, and privilege delegation.

Addressing the issues identified will significantly improve the security posture of the Windows domain and reduce the likelihood of successful lateral movement or privilege escalation during a real-world attack.