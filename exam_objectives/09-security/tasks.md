# 09 - Manage Security

## Task 1: Key-based Authentication (node1 to node2)
1.1 On node2, allow SSH login as root.
1.2 On node1, generate an SSH key for root.
1.3 Set up key-based authentication so root on node1 can SSH to root on node2 without a password.
1.4 Test it with `ssh root@node2`.

## Task 2: Web Server and SELinux (node1)
2.1 The httpd web server on node1 (192.168.70.10) must serve the website on port 85.
2.2 Fix the SELinux context of /var/www/html if needed.
2.3 Make sure port 85 is open in the firewall.
2.4 Test with `curl http://192.168.70.10:85`
