# Mock Exam Setup

## 1. Create 3 VMs

| VM | IP | Extra disks |
|----|----|-------------|
| repo | 192.168.70.5 | none (attach the full DVD ISO as CD/DVD) |
| node1 | 192.168.70.10 | /dev/vdb 2GB (for labs 04 and 05) |
| node2 | 192.168.70.20 | /dev/vdb 2GB, /dev/vdc 1GB |

- RHEL 10, Rocky Linux 10 or AlmaLinux 10, minimal install, 2 vCPU, 2GB RAM, 20GB disk each. Use the same distro on all 3 VMs.
- The repo server needs the **full DVD ISO** (not the boot or minimal ISO), since it copies BaseOS and AppStream from it.
- All on one network: `192.168.70.0/24`, gateway `192.168.70.1`.
- Set the IPs during install. The repo server also needs internet access.
- Disks may show as `/dev/sdb` and `/dev/sdc` on some hypervisors. If so, change `vdc` in `prep-node2.sh` and use `sdb` in the exam.

## 2. Run the scripts as root

> **Doing the objective labs?** Only run `setup-repo.sh` on the repo VM, then snapshot node1 and node2. The two prep scripts are for the mock exam only.

Copy the scripts to each VM (`scp`, or `git clone` this repo), then run them in this order:

```bash
# on repo
bash setup-repo.sh

# on node1
bash prep-node1.sh

# on node2
bash prep-node2.sh
```

Each script prints a "ready" line when it's done.

## 3. Snapshot

Snapshot node1 and node2 now. Revert to the snapshot to retake the exam.

## 4. Start

Open the [exam](./exam.md), start a 3 hour timer, and use the VM consoles.
