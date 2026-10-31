# RHCSA EX200 Mock Exam - Solutions

Try the [exam](./exam.md) first. Run everything as root unless stated otherwise.

---

## node1

### 1. Networking
Use the console: changing the IP drops SSH.
```bash
nmcli con show                          # note the connection name, e.g. enp1s0
nmcli con mod "enp1s0" ipv4.method manual \
  ipv4.addresses 192.168.70.10/24 \
  ipv4.gateway 192.168.70.1 \
  ipv4.dns 192.168.70.5 \
  connection.autoconnect yes
nmcli con up "enp1s0"

# Verify
ip addr show
ip route
cat /etc/resolv.conf
```

### 2. Hostname
```bash
hostnamectl set-hostname servera.rhcsa.home

# Verify
hostname
```

### 3. Repositories
```bash
vi /etc/yum.repos.d/rhcsa.repo
```
```ini
[BaseOS]
name=BaseOS
baseurl=http://repo.rhcsa.home/repo/BaseOS/
enabled=1
gpgcheck=0

[AppStream]
name=AppStream
baseurl=http://repo.rhcsa.home/repo/AppStream/
enabled=1
gpgcheck=0
```
```bash
dnf clean all

# Verify
dnf repolist
```

### 4. Users and groups
```bash
groupadd teamgrp
useradd -G teamgrp james
useradd -G teamgrp olivia
useradd -s /sbin/nologin emma

echo "james:flamingo" | chpasswd
echo "olivia:flamingo" | chpasswd
echo "emma:flamingo" | chpasswd

# Verify
id james
id olivia
id emma
grep emma /etc/passwd                   # /sbin/nologin
```

### 5. User with UID
```bash
useradd -u 3456 lucas
echo "lucas:flamingo" | chpasswd

# Verify
id lucas
```

### 6. Password aging
For users created from now on:
```bash
vi /etc/login.defs
PASS_MAX_DAYS   25
```
The users from tasks 4 and 5 already exist, so set them too:
```bash
chage -M 25 james
chage -M 25 olivia
chage -M 25 emma
chage -M 25 lucas

# Verify
chage -l james
```
> Doing this task before task 4 saves the `chage` step. On the exam, read all tasks first.

### 7. Find files
```bash
mkdir -p /root/daniel-files
find / -type f -user daniel -not -path "/proc/*" -exec cp {} /root/daniel-files/ \; 2>/dev/null

# Verify
ls -l /root/daniel-files
```

### 8. Collaborative directory
```bash
mkdir /home/teamwork
chgrp teamgrp /home/teamwork
chmod 2770 /home/teamwork

# Verify
ls -ld /home/teamwork                   # drwxrws---. root teamgrp
su - james -c "touch /home/teamwork/test"
ls -l /home/teamwork/test               # group is teamgrp
```

### 9. Web server
Three problems: the SELinux port, the file's SELinux context, and the file permissions.
```bash
systemctl status httpd                  # fails to start

# SELinux port
dnf install -y policycoreutils-python-utils
semanage port -a -t http_port_t -p tcp 84

# File context (the file was moved from /root)
ls -Z /var/www/html/page1.html          # admin_home_t
restorecon -v /var/www/html/page1.html
ls -Z /var/www/html/page1.html          # httpd_sys_content_t

# Permissions
ls -l /var/www/html/page1.html          # -rw-------
chmod 644 /var/www/html/page1.html

# Firewall and service
firewall-cmd --permanent --add-port=84/tcp
firewall-cmd --reload
systemctl enable --now httpd

# Verify
curl http://servera.rhcsa.home:84/page1.html
```

### 10. Search text
```bash
grep ocean /usr/share/dict/words > /root/ocean.txt

# Verify
cat /root/ocean.txt
```

### 11. Archive
```bash
mkdir -p /backup
tar -czf /backup/doc_backup.tar.gz /usr/share/doc

# Verify
file /backup/doc_backup.tar.gz
```

### 12. Cron job
```bash
crontab -e -u olivia
*/4 * * * * logger "Mock exam in progress"

# Verify
crontab -l -u olivia
# after 4 minutes:
journalctl | grep "Mock exam in progress"
```

### 13. NTP
```bash
dnf install -y chrony
vi /etc/chrony.conf
# comment out the existing pool line, then add:
server repo.rhcsa.home iburst

systemctl enable chronyd
systemctl restart chronyd

# Verify
chronyc sources                         # repo.rhcsa.home, ^* when synced
```

### 14. Autofs home directory
```bash
useradd -u 3001 -M -b /remotehome netuser1
echo "netuser1:flamingo" | chpasswd

dnf install -y autofs nfs-utils

vi /etc/auto.master.d/remotehome.autofs
/remotehome  /etc/auto.remotehome

vi /etc/auto.remotehome
netuser1  -rw,sync  repo.rhcsa.home:/home/netuser1

systemctl enable --now autofs

# Verify
su - netuser1
pwd                                     # /remotehome/netuser1
touch testfile
exit
```

---

## node2

### 15. Root password
1. Reboot node2. At the GRUB menu press `e` on the default entry
2. Add `rd.break` to the end of the line starting with `linux`
3. Press `Ctrl+x`
4. Then:
```bash
mount -o remount,rw /sysroot
chroot /sysroot
passwd root                             # flamingo
touch /.autorelabel
exit
exit
```
Wait for the relabel and reboot, then log in with `flamingo`.

### 16. Resize a logical volume
```bash
lvs                                     # datalv is 200M
df -hT /data                            # ext4
lvresize -r -L 300M /dev/datavg/datalv

# Verify
lvs
df -h /data
```
> XFS can grow but not shrink. If the task asks you to make an XFS volume smaller, it can't be done in place.

### 17. Repositories
Same as task 3, on node2.

### 18. New logical volume
If your disk is `/dev/sdb`, replace `vdb` with `sdb` in tasks 18 and 19.

16MB x 40 = 640MB, so the LVM partition needs more than 640MB.
```bash
lsblk /dev/vdb
parted /dev/vdb mklabel gpt
parted /dev/vdb mkpart lvm 1MiB 801MiB
parted /dev/vdb set 1 lvm on
udevadm settle

pvcreate /dev/vdb1
vgcreate -s 16M finance /dev/vdb1
lvcreate -l 40 -n payroll finance
mkfs.ext3 /dev/finance/payroll
mkdir -p /mnt/payroll

vi /etc/fstab
/dev/finance/payroll  /mnt/payroll  ext3  defaults  0 0

systemctl daemon-reload
mount -a

# Verify
vgdisplay finance | grep "PE Size"      # 16.00 MiB
lvs                                     # 640.00m
df -hT /mnt/payroll                     # ext3
```

### 19. Swap
```bash
parted /dev/vdb mkpart swap linux-swap 801MiB 1313MiB
udevadm settle
mkswap /dev/vdb2
blkid /dev/vdb2                         # copy the UUID

vi /etc/fstab
UUID=<uuid>  none  swap  defaults  0 0

systemctl daemon-reload
swapon -a

# Verify
swapon --show                           # /dev/vdb2 512M plus the existing swap
```

### 20. Tuning profile
```bash
dnf install -y tuned
systemctl enable --now tuned
tuned-adm recommend
tuned-adm profile <recommended-profile>

# Verify
tuned-adm active
```

### 21. Rootless container as a service

As root:
```bash
dnf install -y podman
mkdir -p /srv/uploads /srv/reports
chown devops:devops /srv/uploads /srv/reports
loginctl enable-linger devops
```

As devops. Log in with SSH, not `su`, or `systemctl --user` fails:
```bash
ssh devops@node2

podman login -u rhcsa -p Passw0rd repo.rhcsa.home:5000
podman run -d --name filebox \
  -v /srv/uploads:/opt/outbox:Z \
  -v /srv/reports:/opt/inbox:Z \
  repo.rhcsa.home:5000/rhcsa/filebox:latest

mkdir -p ~/.config/systemd/user
cd ~/.config/systemd/user
podman generate systemd --name filebox --files --new
podman stop filebox
podman rm filebox

systemctl --user daemon-reload
systemctl --user enable --now container-filebox.service
```
> `podman generate systemd` prints a deprecation warning. Ignore it, the unit file is still created.

Verify:
```bash
systemctl --user status container-filebox.service
touch /srv/uploads/from-host
podman exec filebox ls /opt/outbox             # from-host
podman exec filebox touch /opt/inbox/from-container
ls -l /srv/reports                             # from-container
```

---

## Final check
```bash
reboot          # both nodes
```
After the reboot, check every task again. As devops on node2, `podman ps` must show `filebox` running.
