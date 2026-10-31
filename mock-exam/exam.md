# RHCSA EX200 Mock Exam

**Time:** 3 hours. **Tasks:** 21.

Build the lab first: see [setup](./setup.md).

## Rules

- No internet, no notes. `man` pages and `/usr/share/doc` are allowed.
- All changes must survive a reboot. Reboot both nodes at the end and check your work.
- Use the VM console. SSH is optional unless a task asks for it.
- If a task can't be done, move on and come back later.

## Environment

| Item | Value |
|------|-------|
| node1 root password | the one you set during install |
| node2 root password | unknown, see Task 15 |
| Repo server | repo.rhcsa.home |
| BaseOS | http://repo.rhcsa.home/repo/BaseOS/ |
| AppStream | http://repo.rhcsa.home/repo/AppStream/ |
| Container registry | repo.rhcsa.home:5000, user `rhcsa`, password `Passw0rd` |
| Default password for new users | `flamingo` |

---

## node1

**1. Networking**
Configure node1 with:
- IP address: 192.168.70.10/24
- Gateway: 192.168.70.1 (or your lab network's gateway, see the setup guide)
- DNS: 192.168.70.5

**2. Hostname**
Set the hostname of node1 to `servera.rhcsa.home`.

The VM is still called node1 in the setup guide and diagram. This task only changes its hostname, like hostname tasks in the real exam. Both names point to 192.168.70.10.

**3. Repositories**
Configure BaseOS and AppStream from the URLs above as the default repositories on node1.

**4. Users and groups**
- Create a group named `teamgrp`
- Create users `james` and `olivia` as members of `teamgrp`
- Create user `emma`, not a member of `teamgrp`, with no interactive login shell
- All three users have the password `flamingo`

**5. User with UID**
Create user `lucas` with UID `3456` and password `flamingo`.

**6. Password aging**
Passwords for all new users must expire after 25 days.

**7. Find files**
Find all files owned by user `daniel` and copy them to `/root/daniel-files`. The user already exists.

**8. Collaborative directory**
Create `/home/teamwork`:
- Group owner is `teamgrp`
- Members of `teamgrp` can read, write and access it. Others have no access.
- New files created in the directory automatically get `teamgrp` as group owner

**9. Web server**
An httpd web server on node1 is configured to listen on port 84 but isn't working. Fix it so that:
- It starts at boot
- Port 84 is reachable from other hosts
- `curl http://servera.rhcsa.home:84/page1.html` shows `mock exam passed`

Don't move or recreate `page1.html`.

**10. Search text**
Find all lines in `/usr/share/dict/words` that contain the string `ocean` and save them, in the original order, to `/root/ocean.txt`.

**11. Archive**
Create a gzip-compressed tar archive of `/usr/share/doc` named `/backup/doc_backup.tar.gz`.

**12. Cron job**
As user `olivia`, run `logger "Mock exam in progress"` every 4 minutes.

**13. NTP**
Configure node1 as a chrony client of `repo.rhcsa.home`.

**14. Autofs home directory**
User `netuser1` (UID `3001`, password `flamingo`) has a home directory exported from `repo.rhcsa.home:/home/netuser1`.
- Create the user on node1 so the home directory is `/remotehome/netuser1`
- Configure autofs so the home directory mounts automatically when `netuser1` logs in

---

## node2

**15. Root password**
Reset the root password of node2 to `flamingo`.

**16. Resize a logical volume**
Resize the logical volume `datalv` and its filesystem to 300MB. A size between 280MB and 320MB is acceptable.

**17. Repositories**
Configure BaseOS and AppStream from the URLs above as the default repositories on node2.

**18. New logical volume**
Using the empty 2GB disk (`/dev/vdb`, or `/dev/sdb` on some systems. Check with `lsblk`):
- Create volume group `finance` with a physical extent size of 16MB
- Create logical volume `payroll` with 40 extents
- Format it as `ext3` and mount it persistently at `/mnt/payroll`

**19. Swap**
Using the remaining space on the same disk, create a 512MB swap partition and activate it persistently. Don't touch the existing swap.

**20. Tuning profile**
Set node2 to use the recommended tuned profile.

**21. Rootless container as a service**
As user `devops`:
- Log in to the registry at `repo.rhcsa.home:5000` and use the image `rhcsa/filebox`
- Run a container named `filebox`
- Map host directory `/srv/uploads` to `/opt/outbox` and `/srv/reports` to `/opt/inbox` in the container
- Files created on the host must be accessible in the container, and the other way round
- Run it as a systemd user service named `container-filebox` that starts at boot, without `devops` logging in

---

**Finished?** Reboot both nodes, then grade yourself as root: run `bash grade-node1.sh` on node1 and `bash grade-node2.sh` on node2. Then compare with the [solutions](./solutions.md).
