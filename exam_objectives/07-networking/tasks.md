# 07 - Manage Basic Networking

All tasks on node1, as root.

## Task 1: Network Service
1.1 Make sure the network service starts at boot.

## Task 2: Firewall
2.1 Allow the SSH and HTTP services through the firewall.

## Task 3: Static IP and Hostname
3.1 Configure node1 with:
   - IP address: `172.16.1.10/24`
   - Gateway: `172.16.1.1`
   - DNS: `172.16.1.1`
   - DNS search domain: `rhel.server.com`
3.2 Set the hostname to `node5.rhcsa`.

Do this task from the VM console, not over SSH. The new IP takes node1 off the lab network, so revert to your snapshot afterwards.
