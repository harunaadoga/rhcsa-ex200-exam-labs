# RHCSA EX200 Quick Reference

The key commands for each exam objective on one page. Practice them in the [labs](../README.md#exam-objectives) first.

## Essential Tools
```bash
grep -i pattern file > out.txt          # search text, save output
tar -czf archive.tar.gz /dir            # gzip archive (-j bzip2, -J xz)
tar -tzf archive.tar.gz                 # list contents
ln -s target link                       # soft link
ln target link                          # hard link
find / -user bob -type f                # files owned by bob
find /usr -size +3M -size -10M          # files by size
find /etc -mtime +120                   # modified more than 120 days ago
find / -name file 2>/dev/null           # find by name
man -k keyword                          # search man pages
```

## Shell Scripts
```bash
#!/bin/bash
if [ "$1" = "yes" ]; then
    echo "yes"
else
    echo "Usage: $0 yes"
fi

for user in alice bob; do
    useradd "$user"
done
```

## Operate Running Systems
```bash
# Reset root password: VM console, reboot, at GRUB press e, Ctrl+e on the linux line
# RHEL 9: add rd.break, Ctrl+x
mount -o remount,rw /sysroot
chroot /sysroot
passwd root
touch /.autorelabel
exit; exit
# RHEL 10: add init=/bin/bash, Ctrl+x
mount -o remount,rw /
passwd root
touch /.autorelabel
exec /sbin/init

systemctl enable --now service          # start now and at boot
systemctl set-default multi-user.target # boot target
tuned-adm recommend                     # recommended tuning profile
tuned-adm profile <profile>             # set profile
nice -n 19 command &                    # start with niceness
renice -n 10 -p <PID>                   # change niceness
mkdir -p /var/log/journal               # persistent journal
journalctl -u httpd                     # logs for a service
scp file user@host:/path                # secure copy
```

## Local Storage
```bash
lsblk
parted /dev/vdb mklabel gpt
parted /dev/vdb mkpart lvm 1MiB 1025MiB
parted /dev/vdb set 1 lvm on
pvcreate /dev/vdb1
vgcreate -s 16M myvg /dev/vdb1          # -s = extent size
lvcreate -l 40 -n mylv myvg             # -l extents, -L size
mkfs.ext4 /dev/myvg/mylv
mkswap /dev/vdb2
swapon -a; swapon
```

`/etc/fstab`:
```
/dev/myvg/mylv   /mnt/data   ext4   defaults   0 0
/dev/vdb2        swap        swap   defaults   0 0
```
```bash
systemctl daemon-reload
mount -a                                # always test fstab before reboot
```

## File Systems
```bash
lvresize -r -L 300M /dev/myvg/mylv      # -r resizes the filesystem too
umount /mnt/data                        # ext4 must be unmounted to shrink (XFS can't shrink)
```

Autofs:
```bash
dnf install -y autofs nfs-utils
# /etc/auto.master.d/home.autofs
/remotehome  /etc/auto.home
# /etc/auto.home
user1  -rw,sync  server:/home/user1
systemctl enable --now autofs
```

## Deploy, Configure, Maintain
```bash
crontab -e -u user                      # */5 * * * * command
at now + 2 minutes                      # Ctrl+d to save
dnf repolist
dnf install -y package
```

`/etc/yum.repos.d/local.repo`:
```ini
[BaseOS]
name=BaseOS
baseurl=http://server/BaseOS/
enabled=1
gpgcheck=0
```
```bash
# /etc/chrony.conf: server ntp.example.com iburst
systemctl restart chronyd; chronyc sources

# /etc/default/grub, then:
grub2-mkconfig -o /boot/grub2/grub.cfg --update-bls-cmdline
```

## Networking
```bash
nmcli con show
nmcli con mod "con" ipv4.method manual ipv4.addresses 192.168.1.10/24 \
  ipv4.gateway 192.168.1.1 ipv4.dns 192.168.1.1 ipv4.dns-search example.com
nmcli con up "con"
hostnamectl set-hostname server.example.com
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-port=85/tcp
firewall-cmd --reload
```
`nmtui` does the same with a menu.

## Users and Groups
```bash
groupadd grp
useradd -u 3000 -G grp -s /sbin/nologin user
echo "user:password" | chpasswd
usermod -aG grp user                    # add to group
gpasswd -d user grp                     # remove from group
userdel -r user                         # delete with home
chage -M 30 user                        # max password age, existing user
# /etc/login.defs: PASS_MAX_DAYS (new users only)
# /etc/security/pwquality.conf: minlen = 8
chmod 2770 /shared; chgrp grp /shared   # setgid collaborative dir
setfacl -m u:user:rw file; getfacl file
```

## Security
```bash
ssh-keygen; ssh-copy-id root@host
# /etc/ssh/sshd_config: PermitRootLogin yes (check sshd_config.d/ too)
getenforce; setenforce 0                # permissive until reboot
# /etc/selinux/config: SELINUX=permissive|enforcing
semanage port -a -t http_port_t -p tcp 85
restorecon -Rv /var/www/html
ls -Z file
ausearch -m avc -ts recent              # SELinux denials
```

## Containers (RHEL 9)
```bash
podman login registry:5000
podman build -t image .
podman run -d --name web -p 8000:80 -v /host:/container:Z image
loginctl enable-linger user             # as root
mkdir -p ~/.config/systemd/user; cd ~/.config/systemd/user
podman generate systemd --name web --files --new
podman stop web; podman rm web
systemctl --user daemon-reload
systemctl --user enable --now container-web.service
```
Log in as the user with SSH, not `su`.

## Flatpak (RHEL 10)
```bash
dnf install -y flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak remotes
flatpak search firefox
flatpak install -y flathub org.mozilla.firefox
flatpak list --app
flatpak uninstall -y org.mozilla.firefox
flatpak uninstall --unused -y
```

## Exam Day
- Read every task before you start. Some depend on others.
- Do the root password reset first if a node needs it.
- Run `mount -a` after every fstab edit.
- Reboot both nodes at the end and check everything again.
