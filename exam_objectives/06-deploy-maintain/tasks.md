# 06 - Deploy, Configure, and Maintain Systems

## Cron & at
- Create a cron job for user `hadoga` that runs `logger "RHCSA Playlist Now Available"` every 2 minutes.
- Use `at` to write "This task was easy!" to `/at-files/at.txt` in 2 minutes.

## YUM Repositories
Configure these repos on node1:
- BaseOS: `http://repo.rhcsa.home/repo/BaseOS/`
- AppStream: `http://repo.rhcsa.home/repo/AppStream/`

Check they show up with `dnf repolist`. In the exam the repo server is provided. In this lab the repos only need to work if you built the optional `repo` VM.

## Chrony
Set up chrony to sync with `server.rhel.com`.

## GRUB Modification
Set GRUB_TIMEOUT=10, GRUB_TIMEOUT_STYLE=hidden, add `quiet` to GRUB_CMDLINE_LINUX. Apply changes.
