#!/bin/bash
# Mock exam: node2 prep. Run as root on node2 after setup-repo.sh.
# WARNING: wipes the empty 1GB disk (/dev/vdc or /dev/sdc).
set -e

# Find the empty 1GB disk, whatever the hypervisor calls it
DISK=$(lsblk -dnbpo NAME,SIZE,TYPE | awk '$3=="disk" && $2>=1000000000 && $2<=1100000000 {print $1; exit}')
if [ -z "$DISK" ]; then
    echo "No 1GB disk found. Add a 1GB disk to node2 and run this again."
    exit 1
fi
if [ "$(lsblk -n "$DISK" | wc -l)" -ne 1 ]; then
    echo "$DISK is not empty. Use a new, empty 1GB disk."
    exit 1
fi
echo "Using $DISK"

# Hostnames
hostnamectl set-hostname node2.rhcsa.home
cat >> /etc/hosts << 'HOSTS'
192.168.70.5   repo.rhcsa.home repo
192.168.70.10  node1.rhcsa.home node1 servera.rhcsa.home
192.168.70.20  node2.rhcsa.home node2
HOSTS

# Task 16: existing logical volume to resize
wipefs -a "$DISK"
pvcreate "$DISK"
vgcreate datavg "$DISK"
lvcreate -y -L 200M -n datalv datavg
mkfs.ext4 /dev/datavg/datalv
mkdir -p /data
echo "/dev/datavg/datalv  /data  ext4  defaults  0 0" >> /etc/fstab
systemctl daemon-reload
mount -a

# Task 21: container user, and allow the HTTP registry
useradd devops
echo "devops:flamingo" | chpasswd
mkdir -p /etc/containers/registries.conf.d
cat > /etc/containers/registries.conf.d/rhcsa.conf << 'REG'
[[registry]]
location = "repo.rhcsa.home:5000"
insecure = true
REG

echo "node2 ready for the mock exam"
