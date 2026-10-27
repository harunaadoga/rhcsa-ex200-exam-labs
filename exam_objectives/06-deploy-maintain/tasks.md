# 06 - Deploy, Configure, and Maintain Systems

All tasks on node1, as root.

## Task 1: Cron & at
1.1 Create a cron job for user `hadoga` that runs `logger "RHCSA Playlist Now Available"` every 2 minutes.
1.2 Use `at` to write `This task was easy!` to `/at-files/at.txt` in 2 minutes.

## Task 2: Repositories
2.1 Configure these repos:
   - BaseOS: `http://repo.rhcsa.home/repo/BaseOS/`
   - AppStream: `http://repo.rhcsa.home/repo/AppStream/`

Check they show up with `dnf repolist`. In the exam the repo server is provided. In this lab the repos only need to work if you built the optional `repo` VM.

## Task 3: Chrony
3.1 Configure chrony to sync with `server.rhel.com`.

This server doesn't exist in the lab, so chrony won't actually sync. Check that it's listed with `chronyc sources`.

## Task 4: GRUB
4.1 Set `GRUB_TIMEOUT=10` and `GRUB_TIMEOUT_STYLE=hidden`, and add `quiet` to `GRUB_CMDLINE_LINUX`.
4.2 Apply the changes.
