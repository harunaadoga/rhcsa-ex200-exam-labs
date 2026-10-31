# 05 - Create & Configure File Systems

## Task 1: Resize Logical Volume
Resize the existing `devops_lv` logical volume to 250MB (acceptable range 225–270MB) and resize the filesystem accordingly.

## Task 2: Autofs for Remote Home Directories
Needs the optional `repo` VM from the [setup guide](../../mock-exam/setup.md).

- Create user `bobby` (UID `2060`, no home dir, base dir `/mnt/netdir`, password `hoppy`)
- Configure NFS autofs so bobby's home mounts at `/mnt/netdir/bobby`
- NFS source: `repo.rhcsa.home:/home/bobby`

Test by logging in as bobby.
