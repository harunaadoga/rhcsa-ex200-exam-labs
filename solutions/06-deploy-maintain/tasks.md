# Solutions - 06 Deploy, Configure, and Maintain Systems

> Run as root on node1.

## Task 1: Cron & at

### 1.1 Cron job for hadoga
```bash
crontab -e -u hadoga
*/2 * * * * logger "RHCSA Playlist Now Available"

# Verify
crontab -l -u hadoga
# wait 2 minutes, then:
journalctl | grep "RHCSA Playlist"
```

### 1.2 at job
```bash
dnf install -y at
systemctl enable --now atd
mkdir -p /at-files

at now + 2 minutes
at> echo "This task was easy!" > /at-files/at.txt
at> <Ctrl+d>

# Verify
atq                         # job is queued
# wait 2 minutes, then:
cat /at-files/at.txt
```

## Task 2: Repositories

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
dnf repolist                # BaseOS and AppStream listed
```

## Task 3: Chrony

```bash
dnf install -y chrony

vi /etc/chrony.conf
# comment out the existing pool line:
#pool 2.rhel.pool.ntp.org iburst
# add:
server server.rhel.com iburst

systemctl enable chronyd
systemctl restart chronyd

# Verify
chronyc sources             # server.rhel.com is listed
```

## Task 4: GRUB

```bash
vi /etc/default/grub
GRUB_TIMEOUT=10
GRUB_TIMEOUT_STYLE=hidden
GRUB_CMDLINE_LINUX="<existing options> quiet"
```
```bash
grub2-mkconfig -o /boot/grub2/grub.cfg --update-bls-cmdline

# Verify
grubby --info=DEFAULT | grep args     # quiet is in the list
reboot
cat /proc/cmdline                      # quiet is in the list
```
