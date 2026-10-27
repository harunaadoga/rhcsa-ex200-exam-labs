# Solutions - 03 Operate Running Systems

## Task 1: Reset Root Password (node2)

1. Reboot node2. At the GRUB menu press `e` on the default kernel entry
2. Go to the end of the line starting with `linux` and add:
   ```
   rd.break
   ```
3. Press `Ctrl+x` to boot
4. At the `switch_root:/#` prompt:
   ```bash
   mount -o remount,rw /sysroot
   chroot /sysroot
   passwd root              # enter: hoppy
   touch /.autorelabel
   exit
   exit
   ```
5. The system relabels SELinux contexts and reboots. Log in as root with `hoppy`.

## Task 2: Tuning Profile, SELinux, Network Service

### Check recommended tuning profile
```bash
dnf install -y tuned        # only if not installed
systemctl enable --now tuned
tuned-adm recommend

# Verify (current active profile)
tuned-adm active
```

### SELinux permissive on node2
```bash
setenforce 0                # now
vi /etc/selinux/config      # persistent, set:
SELINUX=permissive

# Verify
getenforce
```

### Network service on node1
```bash
systemctl enable --now NetworkManager

# Verify
systemctl is-enabled NetworkManager
systemctl is-active NetworkManager
```

## Task 3: Persistent Journaling (node1 and node2)

```bash
mkdir -p /var/log/journal
systemctl restart systemd-journald

# Verify
ls /var/log/journal/        # a directory named after the machine ID appears
reboot
journalctl --list-boots     # shows more than one boot after reboot
```

## Task 4: Process Scheduling (node1)

```bash
dnf install -y stress-ng

# Start with niceness 19
nice -n 19 stress-ng --cpu 1 &

# Check PID and niceness
ps -o pid,ni,comm -C stress-ng

# Change niceness to 10 (use the PID from above)
renice -n 10 -p <PID>

# Verify
ps -o pid,ni,comm -C stress-ng

# Terminate
pkill stress-ng

# Verify
ps -C stress-ng
```

## Task 5: File Permissions & ACLs

```bash
cp /etc/fstab /var/tmp/
chown root:root /var/tmp/fstab
chmod a-x /var/tmp/fstab

setfacl -m u:adam:rw /var/tmp/fstab
setfacl -m u:maryam:- /var/tmp/fstab
setfacl -m o::r /var/tmp/fstab

# Verify
getfacl /var/tmp/fstab
```

## Task 6: Secure File Transfer (node1)

```bash
touch node1-file.ext
scp node1-file.ext hadoga@node2:/home/hadoga/

# Verify
ssh hadoga@node2 ls -l /home/hadoga/node1-file.ext
```
