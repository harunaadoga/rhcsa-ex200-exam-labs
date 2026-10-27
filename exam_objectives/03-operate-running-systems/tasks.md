# 03 - Operate Running Systems

## Task 1: Reset Root Password (node2)
1.1 Break into node2 and set the root password to `hoppy`.

## Task 2: Tuning Profile, SELinux and Network Service
2.1 Check the recommended tuning profile.
2.2 Put SELinux in permissive mode on node2.
2.3 On node1, make sure the network service is enabled and starts at boot.

## Task 3: Persistent Journaling (node1 and node2)
3.1 Configure persistent journaling so logs are kept across reboots.

## Task 4: Process Scheduling (node1)
4.1 Start a stress-ng process with a niceness of 19.
4.2 Change its niceness to 10.
4.3 Terminate the stress-ng process.

## Task 5: File Permissions & ACLs (node1)
Users adam and maryam must exist (created in objective 02).

5.1 Copy /etc/fstab to /var/tmp.
5.2 Set the owner to root.
5.3 Remove execute permissions for everyone.
5.4 Configure ACLs on /var/tmp/fstab:
   - adam: read and write
   - maryam: no access
   - others: read only

## Task 6: Secure File Transfer (node1)
6.1 Create `node1-file.ext` and copy it securely to user hadoga's home directory on node2.
