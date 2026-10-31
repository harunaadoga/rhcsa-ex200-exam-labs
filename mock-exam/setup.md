# Lab Setup

Used for the objective labs and the mock exam.

## 1. Create the VMs

| VM | IP | Extra disks |
|----|----|-------------|
| node1 | 192.168.70.10 | one 2GB disk |
| node2 | 192.168.70.20 | one 2GB disk and one 1GB disk |
| repo (optional for labs, needed for mock exam) | 192.168.70.5 | none (attach the full DVD ISO as CD/DVD) |

- RHEL 10, Rocky Linux 10 or AlmaLinux 10, minimal install, 2 vCPU, 2GB RAM, 20GB disk each. Use the same distro on all VMs.
- All on one network: `192.168.70.0/24`, gateway `192.168.70.1`, with internet access. Set the IPs during install.
- The repo VM needs the **full DVD ISO** (not the boot or minimal ISO), since it copies BaseOS and AppStream from it.
- Extra disks show up as `/dev/vdb` and `/dev/vdc` on some hypervisors, or `/dev/sdb` and `/dev/sdc` on others. Check with `lsblk` and use the names you see.

## 2. Prepare node1 and node2

Run as root on **both** node1 and node2:

```bash
cat >> /etc/hosts << 'EOF'
192.168.70.5   repo.rhcsa.home repo
192.168.70.10  node1.rhcsa.home node1
192.168.70.20  node2.rhcsa.home node2
EOF

useradd -G wheel hadoga
passwd hadoga
```

## 3. Set up the repo VM

Needed for labs 05 and 10, and for the mock exam. Run as root on the repo VM:

```bash
curl -O https://raw.githubusercontent.com/harunaadoga/rhcsa-ex200-exam-labs/main/mock-exam/setup-repo.sh
bash setup-repo.sh
```

It prints `repo server ready` when it's done.

## 4. Snapshot node1 and node2

Name the snapshot `clean`. You can now start the objective labs.

## 5. Mock exam only

Revert node1 and node2 to `clean`, then run as root:

```bash
# on node1
curl -O https://raw.githubusercontent.com/harunaadoga/rhcsa-ex200-exam-labs/main/mock-exam/prep-node1.sh
bash prep-node1.sh

# on node2
curl -O https://raw.githubusercontent.com/harunaadoga/rhcsa-ex200-exam-labs/main/mock-exam/prep-node2.sh
bash prep-node2.sh
```

Then open the [exam](./exam.md), start a 3 hour timer, and use the VM consoles.
