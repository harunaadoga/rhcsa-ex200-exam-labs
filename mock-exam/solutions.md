# RHCSA EX200 Mock Exam - Solutions

Try the [exam](./exam.md) first. Run everything as root unless stated otherwise.

---

## node1

### 1. Networking
node1 starts on the wrong network (10.0.0.10), so use the console. Once this is done, SSH works again.
```bash
nmcli con show                          # note the connection name, e.g. enp1s0
nmcli con mod "enp1s0" ipv4.method manual \
  ipv4.addresses 192.168.70.10/24 \
  ipv4.gateway 192.168.70.1 \
  ipv4.dns 192.168.70.5 \
  ipv4.dns-search rhcsa.home \
  connection.autoconnect yes
nmcli con up "enp1s0"

# Verify
ip addr show
ip route
cat /etc/resolv.conf
```

You can also use `nmtui` instead. It is available in the exam, and either tool is fine:
1. Run `nmtui` and choose **Edit a connection**, then your connection.
2. Set **IPv4 CONFIGURATION** to **Manual**, then **Show**. Replace the address with `192.168.70.10/24`, set the gateway to `192.168.70.1`, the DNS server to `192.168.70.5` and the search domain to `rhcsa.home`.
3. Make sure **Automatically connect** is ticked, then choose **OK** and **Back**.
4. Choose **Activate a connection**, then **Deactivate** and **Activate** your connection to apply the change.

Then run the same verify commands.

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
```
Change the `PASS_MAX_DAYS` line to this, then save and quit:
```
PASS_MAX_DAYS   25
```
Verify:
```bash
grep ^PASS_MAX_DAYS /etc/login.defs     # PASS_MAX_DAYS   25
```
> The task asks for users created from now on, so existing users don't need changing.
>
> In the real exam the task may only say "set the password age to 25 days", without saying new or existing users. Then do both: set `PASS_MAX_DAYS` in `/etc/login.defs`, and run `chage -M` on the users that already exist.

### 7. Find files
Create the directory first. Copying into a directory that doesn't exist fails, or creates a single file instead. If `find` prints messages about `/proc`, ignore them. The copy still works.
```bash
mkdir /root/daniel-files
find / -type f -user daniel -exec cp {} /root/daniel-files/ \;

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
Three problems: the SELinux port, the file's permissions, and the file's SELinux context. Find them one at a time: try it, read the error, fix it.

**1. Try to start httpd**
```bash
systemctl start httpd                   # fails
journalctl -u httpd --no-pager -n 20    # Permission denied ... make_sock ... :84
```
SELinux only lets httpd use the ports in `http_port_t`, and 84 isn't one of them.

**2. Allow port 84 in SELinux, then start httpd**
```bash
dnf install -y policycoreutils-python-utils
semanage port -l | grep http_port_t     # 84 is not in the list
semanage port -a -t http_port_t -p tcp 84

systemctl enable --now httpd
systemctl status httpd                  # active (running)
```

**3. Try the page**
```bash
curl http://localhost:84/page1.html     # 403 Forbidden
ls -lZ /var/www/html/page1.html         # -rw------- ... admin_home_t
```
Two problems: only root can read the file, and its SELinux label is wrong because it was moved from /root.
```bash
chmod 644 /var/www/html/page1.html
restorecon -v /var/www/html/page1.html

curl http://localhost:84/page1.html     # mock exam passed
```

**4. Open the firewall for other hosts**
```bash
firewall-cmd --permanent --add-port=84/tcp
firewall-cmd --reload
```
Verify from node2:
```bash
curl http://servera.rhcsa.home:84/page1.html   # mock exam passed
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
```
Add this line, then save and quit:
```
*/4 * * * * logger "Mock exam in progress"
```
Verify:
```bash
crontab -l -u olivia
# after 4 minutes:
journalctl | grep "Mock exam in progress"
```

### 13. NTP
```bash
dnf install -y chrony
vi /etc/chrony.conf
```
Put `#` in front of the `pool` line, add this line, then save and quit:
```
server repo.rhcsa.home iburst
```
```bash
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
```
Add this line, then save and quit:
```
/remotehome  /etc/auto.remotehome
```
```bash
vi /etc/auto.remotehome
```
Add this line, then save and quit:
```
netuser1  -rw,sync  repo.rhcsa.home:/home/netuser1
```
```bash
systemctl enable --now autofs

# Verify
su - netuser1
pwd                                     # /remotehome/netuser1
touch testfile
exit
```

> As root, `ls /remotehome/netuser1` says Permission denied. That's normal: the NFS server treats root from other machines as an unknown user. Test as `netuser1`, as above.

---

## node2

### 15. Root password
Use the VM console, not SSH. You need to see the screen from the moment it boots.

**Open the GRUB editor (RHEL 9 and 10)**
1. Reboot the VM from its console.
2. When the boot menu appears, press the Down arrow to stop the countdown, then Up to go back to the top entry. The top entry is your normal kernel. Don't use the rescue entry.
3. Press `e`. Move down to the line that starts with `linux` and press `Ctrl+e` to jump to the end of it.

**RHEL 9: `rd.break`**

4. Type a space and `rd.break`, then press `Ctrl+x`.
5. At the `switch_root:/#` prompt:
```bash
mount -o remount,rw /sysroot
chroot /sysroot
passwd root                             # flamingo
touch /.autorelabel
exit
exit
```

**RHEL 10: `init=/bin/bash`**

On RHEL 10, `rd.break` asks for the root password, so use this instead. It works on RHEL 9 too.

4. Type a space and `init=/bin/bash`, then press `Ctrl+x`.
5. At the `bash-5.2#` prompt:
```bash
mount -o remount,rw /
passwd root                             # flamingo
touch /.autorelabel
exec /sbin/init
```

Nothing shows on screen while you type the password. That's normal. The SELinux relabel runs and the VM reboots by itself. Then log in as root with `flamingo`.

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
```
Add this line at the end, then save and quit:
```
/dev/finance/payroll  /mnt/payroll  ext3  defaults  0 0
```
```bash
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
```
Add this line at the end, with your UUID, then save and quit:
```
UUID=<uuid>  none  swap  defaults  0 0
```
```bash
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

### 21a. RHEL 9: Rootless container as a service

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

### 21b. RHEL 10: Flatpak

As root. Flatpak commands run as root work system-wide.
```bash
dnf install -y flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub org.mozilla.firefox
```
> The install also downloads the runtime Firefox needs, so it can take a few minutes.

Verify:
```bash
flatpak remotes                                # flathub  system
flatpak list --app                             # Firefox
```

---

## Final check
```bash
reboot          # both nodes
```
After the reboot, check every task again.
- 21a: as devops on node2, `podman ps` must show `filebox` running.
- 21b: `flatpak list --app` must show Firefox.
