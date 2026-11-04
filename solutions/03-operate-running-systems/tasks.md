# Solutions - 03 Operate Running Systems

## Task 1: Reset Root Password (node2)

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
passwd root                             # hoppy
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
passwd root                             # hoppy
touch /.autorelabel
exec /sbin/init
```

Nothing shows on screen while you type the password. That's normal. The SELinux relabel runs and the VM reboots by itself. Then log in as root with `hoppy`.

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
vi /etc/selinux/config      # persistent
```
Change the `SELINUX` line to this, then save and quit:
```
SELINUX=permissive
```
```bash
# Verify
getenforce                  # Permissive
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
