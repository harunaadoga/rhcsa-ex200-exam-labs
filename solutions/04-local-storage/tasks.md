# Solutions - 04 Configure Local Storage

> Run as root on node1. /dev/vdb must be empty: `mklabel` wipes the partition table.

## Partition /dev/vdb

```bash
lsblk /dev/vdb

parted /dev/vdb mklabel gpt
parted /dev/vdb mkpart lvm 1MiB 1025MiB
parted /dev/vdb set 1 lvm on
parted /dev/vdb mkpart swap linux-swap 1025MiB 1825MiB
udevadm settle

# Verify
lsblk /dev/vdb              # vdb1 = 1G, vdb2 = 800M
```

## Task 1: LVM Setup

```bash
pvcreate /dev/vdb1
vgcreate -s 20M devops_vg /dev/vdb1
lvcreate -l 32 -n devops_lv devops_vg
mkfs.ext4 /dev/devops_vg/devops_lv
mkdir -p /mnt/devops_lv
```

Add to /etc/fstab:
```bash
vi /etc/fstab
/dev/devops_vg/devops_lv  /mnt/devops_lv  ext4  defaults  0 0
```

```bash
systemctl daemon-reload
mount -a

# Verify
vgdisplay devops_vg | grep "PE Size"     # 20.00 MiB
lvdisplay devops_vg/devops_lv | grep "Current LE"   # 32
lvs                                       # 640.00m
df -h /mnt/devops_lv
```

## Task 2: Swap Partition

```bash
mkswap /dev/vdb2
blkid /dev/vdb2             # copy the UUID
```

Add to /etc/fstab:
```bash
vi /etc/fstab
UUID=<uuid-from-blkid>  none  swap  defaults  0 0
```

```bash
systemctl daemon-reload
swapon -a

# Verify
swapon --show               # /dev/vdb2 800M
free -h
```

## Final Check

```bash
reboot
df -h /mnt/devops_lv
swapon --show
```
