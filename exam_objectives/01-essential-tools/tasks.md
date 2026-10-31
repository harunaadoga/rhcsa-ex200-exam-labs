# 01 - Understand and Use Essential Tools

## Task 1: Text Search & Archive - Man pages
1.1 Find the string "Listen" in /etc/httpd/conf/httpd.conf and save the output to /root/web.txt

1.2 Create a gzip-compressed tar archive of /etc named etc_vault.tar.gz in /vaults directory.
   - Use man pages for gzip option.

## Task 2: File Links - Shortcuts
2.1 In /shorts directory:
   - Create a file file_a
   - Create soft link file_b pointing to file_a
   - Create hard link file_c pointing to file_a
   - Verify all links work

## Task 3: Advanced File Operations - Find
3.1 Find files in /usr that are greater than 3MB but < 10MB and copy them to /bigfiles directory.
3.2 Find files in /etc modified more than 120 days ago and copy them to /var/tmp/twenty/
3.3 Find all files owned by user hadoga and copy them to /root/h-files
3.4 Find a file named "httpd.conf" and save the absolute paths to /root/httpd-paths.txt

## Task 4: Remote Access & File Permissions
4.1 From node1, SSH into node2 as user hadoga and:
   - 4.2 Copy the contents of /etc/fstab to /var/tmp
   - 4.3 Set the file ownership to root
   - 4.4 Ensure no execute permissions for anyone
