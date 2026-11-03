# Solutions - 09 Manage Security

## Key-based Authentication (node1 to node2)

### Allow root SSH login (on node2)
RHEL, Rocky and AlmaLinux 9 and 10 block root password login by default, so `ssh-copy-id` as root fails until this is changed.
```bash
grep -r PermitRootLogin /etc/ssh/sshd_config /etc/ssh/sshd_config.d/
```
Set it in the first file that has it, or in sshd_config if no drop-in file has it:
```bash
vi /etc/ssh/sshd_config
PermitRootLogin yes
```
```bash
systemctl restart sshd

# Verify
sshd -T | grep -i permitrootlogin      # permitrootlogin yes
```

### Generate key and copy it (on node1)
```bash
ssh-keygen                  # press Enter for all prompts
ssh-copy-id root@node2      # enter node2 root password once

# Verify
ssh root@node2              # logs in with no password prompt
```

## HTTPD + SELinux (node1)

Set the port, try to start httpd, read the error, fix it.

### Set the port
```bash
dnf install -y httpd policycoreutils-python-utils

vi /etc/httpd/conf/httpd.conf
Listen 85

systemctl start httpd                   # fails
journalctl -u httpd --no-pager -n 20    # Permission denied ... make_sock ... :85
```
SELinux only lets httpd use the ports in `http_port_t`, and 85 isn't one of them.

### Allow port 85 in SELinux
```bash
semanage port -l | grep http_port_t     # 85 is not in the list
semanage port -a -t http_port_t -p tcp 85
semanage port -l | grep http_port_t     # 85 is in the list
```
> Forgot the syntax? `man semanage-port` has it under EXAMPLES.

### Start httpd
```bash
systemctl enable --now httpd
systemctl status httpd                  # active (running)
```

### Check the /var/www/html context
```bash
ls -Zd /var/www/html                    # httpd_sys_content_t
restorecon -Rv /var/www/html            # fixes it if it's wrong
echo "RHCSA works" > /var/www/html/index.html
```

### Open the firewall and test
```bash
firewall-cmd --permanent --add-port=85/tcp
firewall-cmd --reload

curl http://192.168.70.10:85             # RHCSA works
```
