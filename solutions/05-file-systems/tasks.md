# Solutions - 05 Create & Configure File Systems

> Run as root on node1.

## Task 1: Resize Logical Volume

devops_lv is 640MB (from objective 04), so this is a shrink. ext4 can shrink but must be unmounted first. (XFS cannot shrink.)

```bash
umount /mnt/devops_lv
lvresize -r -L 250M /dev/devops_vg/devops_lv
mount -a

# Verify
lvs                         # 260.00m
df -h /mnt/devops_lv
```
> With 20MB extents, 250MB is rounded up to 260MB (13 extents). That's inside the 225 to 270MB range.

## Task 2: Autofs for Remote Home Directories

### Create user bobby
```bash
useradd -u 2060 -M -b /mnt/netdir bobby
echo "bobby:hoppy" | chpasswd

# Verify
grep bobby /etc/passwd      # home is /mnt/netdir/bobby
```

### Configure autofs
```bash
dnf install -y autofs nfs-utils

vi /etc/auto.master.d/netdir.autofs
/mnt/netdir  /etc/auto.netdir

vi /etc/auto.netdir
bobby  -rw,sync  repo.rhcsa.home:/home/bobby

systemctl enable --now autofs
```

### Verify
```bash
su - bobby
pwd                         # /mnt/netdir/bobby
touch testfile
ls -l
exit

mount | grep netdir         # shows the NFS mount
```
