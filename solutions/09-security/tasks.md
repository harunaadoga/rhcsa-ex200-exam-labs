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

```bash
dnf install -y httpd policycoreutils-python-utils

vi /etc/httpd/conf/httpd.conf
Listen 85
```

### Allow port 85 in SELinux
```bash
semanage port -a -t http_port_t -p tcp 85

# Verify
semanage port -l | grep http_port_t    # 85 in the list
```

### Fix /var/www/html context
```bash
ls -Zd /var/www/html        # should be httpd_sys_content_t
restorecon -Rv /var/www/html
echo "RHCSA works" > /var/www/html/index.html
ls -Z /var/www/html/index.html
```

### Firewall and service
```bash
firewall-cmd --permanent --add-port=85/tcp
firewall-cmd --reload

systemctl enable --now httpd

# Verify
systemctl status httpd
ss -tlnp | grep 85
curl http://192.168.70.10:85
```

### If httpd won't start
```bash
journalctl -u httpd
ausearch -m avc -ts recent  # SELinux denials
```
