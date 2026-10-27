# RHCSA EX200 Exam Labs

Free, hands-on practice labs for the **Red Hat Certified System Administrator (RHCSA)** exam (EX200), organised by the official exam objectives. Every lab has a matching video walkthrough on YouTube.

**Works on RHEL, Rocky Linux and AlmaLinux, versions 9 and 10.**

[![YouTube Playlist](https://img.shields.io/badge/YouTube-RHCSA%20Playlist-red?logo=youtube)](https://www.youtube.com/playlist?list=PLiI_-JOspy6FuSPXSipE0xE4oC2XXYyuI)
![License](https://img.shields.io/badge/license-GPL--3.0-blue)

---

## Quick Links

- [Free RHCSA Hands-on YouTube Playlist](https://www.youtube.com/playlist?list=PLiI_-JOspy6FuSPXSipE0xE4oC2XXYyuI)
- [Official RHCSA Exam Objectives](https://www.redhat.com/en/services/training/ex200-red-hat-certified-system-administrator-rhcsa-exam)
- [Mock Exam](./mock-exam/exam.md)
- [Quick Reference](./docs/quick-reference.md)

## Exam Versions

| Exam version | Extra objective |
|---------|-----------------|
| RHCSA on RHEL 9 | Manage Containers (Podman) |
| RHCSA on RHEL 10 | Manage Software with Flatpak |

## Which Linux to Use

The exam runs on RHEL, but Rocky Linux and AlmaLinux are rebuilds of RHEL, so the same commands work on all three.

| Distro | Cost | Notes |
|--------|------|-------|
| [RHEL](https://developers.redhat.com/register) | Free developer subscription | Exactly what the exam uses |
| [Rocky Linux](https://rockylinux.org/download) | Free | No account needed |
| [AlmaLinux](https://almalinux.org/get-almalinux/) | Free | No account needed |

Use the same major version as your exam: 9 for the RHEL 9 exam, 10 for the RHEL 10 exam.

## How to Use

1. Build the lab: `node1` and `node2` running RHEL, Rocky Linux or AlmaLinux. A third `repo` VM is optional for the labs and needed for the mock exam. See the [setup guide](./mock-exam/setup.md).
2. Work through each objective in order
3. Try every task **before** opening the solution
4. Watch the matching video if you get stuck
5. Finish with the mock exam

---

## Exam Objectives

| # | Objective | Tasks | Solutions | Video |
|---|-----------|-------|-----------|-------|
| 01 | Understand and Use Essential Tools | [Tasks](./exam_objectives/01-essential-tools/tasks.md) | [Solutions](./solutions/01-essential-tools/tasks.md) | [▶ Part 1](https://www.youtube.com/watch?v=Nf5Q1kMw6cM&list=PLiI_-JOspy6FuSPXSipE0xE4oC2XXYyuI) |
| 02 | Create Simple Shell Scripts | [Tasks](./exam_objectives/02-shell-scripts/tasks.md) | [Solutions](./solutions/02-shell-scripts/tasks.md) | [▶ Part 2](https://www.youtube.com/watch?v=EzkUlseWso4&list=PLiI_-JOspy6FuSPXSipE0xE4oC2XXYyuI) |
| 03 | Operate Running Systems | [Tasks](./exam_objectives/03-operate-running-systems/tasks.md) | [Solutions](./solutions/03-operate-running-systems/tasks.md) | [▶ Part 3](https://www.youtube.com/watch?v=aeDBzawCJiI&list=PLiI_-JOspy6FuSPXSipE0xE4oC2XXYyuI) |
| 04 | Configure Local Storage | [Tasks](./exam_objectives/04-local-storage/tasks.md) | [Solutions](./solutions/04-local-storage/tasks.md) | [▶ Part 4](https://www.youtube.com/watch?v=5jbNvO2RR1U&list=PLiI_-JOspy6FuSPXSipE0xE4oC2XXYyuI) |
| 05 | Create and Configure File Systems | [Tasks](./exam_objectives/05-file-systems/tasks.md) | [Solutions](./solutions/05-file-systems/tasks.md) | [▶ Part 5](https://www.youtube.com/watch?v=SCwQ7XLsyVo&list=PLiI_-JOspy6FuSPXSipE0xE4oC2XXYyuI) |
| 06 | Deploy, Configure, and Maintain Systems | [Tasks](./exam_objectives/06-deploy-maintain/tasks.md) | [Solutions](./solutions/06-deploy-maintain/tasks.md) | [▶ Part 6](https://www.youtube.com/watch?v=Lb70UqXPmJs&list=PLiI_-JOspy6FuSPXSipE0xE4oC2XXYyuI) |
| 07 | Manage Basic Networking | [Tasks](./exam_objectives/07-networking/tasks.md) | [Solutions](./solutions/07-networking/tasks.md) | [▶ Part 7](https://www.youtube.com/watch?v=49mL0AZnpxM&list=PLiI_-JOspy6FuSPXSipE0xE4oC2XXYyuI) |
| 08 | Manage Users and Groups | [Tasks](./exam_objectives/08-users-groups/tasks.md) | [Solutions](./solutions/08-users-groups/tasks.md) | [▶ Part 8](https://www.youtube.com/watch?v=VzyppUlTXFs&list=PLiI_-JOspy6FuSPXSipE0xE4oC2XXYyuI) |
| 09 | Manage Security | [Tasks](./exam_objectives/09-security/tasks.md) | [Solutions](./solutions/09-security/tasks.md) | [▶ Part 9](https://www.youtube.com/watch?v=Ks82UfTHEw8&list=PLiI_-JOspy6FuSPXSipE0xE4oC2XXYyuI) |
| 10 | Manage Containers (RHEL 9) | [Tasks](./exam_objectives/10-containers/tasks.md) | [Solutions](./solutions/10-containers/tasks.md) | [▶ Part 10](https://www.youtube.com/watch?v=iY5pFQPzZQg&list=PLiI_-JOspy6FuSPXSipE0xE4oC2XXYyuI) |
| 11 | Manage Software: Flatpak (RHEL 10) | [Tasks](./exam_objectives/11-flatpak/tasks.md) | [Solutions](./solutions/11-flatpak/tasks.md) | [▶ Part 11](https://www.youtube.com/watch?v=uQLkdbPYxcY&list=PLiI_-JOspy6FuSPXSipE0xE4oC2XXYyuI) |

---

## Mock Exam

21 tasks across 2 servers in 3 hours, covering the exam objectives. Take it after you finish the labs.

1. [Setup](./mock-exam/setup.md): 3 VMs and 3 scripts
2. [Exam](./mock-exam/exam.md)
3. [Solutions](./mock-exam/solutions.md)

---
## Disclaimer

This is an independent, community project. It is not affiliated with, endorsed by, or sponsored by Red Hat, Inc.

All tasks are original practice material based on the publicly available [EX200 exam objectives](https://www.redhat.com/en/services/training/ex200-red-hat-certified-system-administrator-rhcsa-exam). This repository does not contain real exam questions or any content covered by the Red Hat exam NDA.

Red Hat, Red Hat Enterprise Linux, RHEL and RHCSA are trademarks of Red Hat, Inc. in the U.S. and other countries.

## Contributing

Found a mistake or have a better solution? See [CONTRIBUTING.md](./CONTRIBUTING.md).

## Support

If these labs helped you prepare or pass, **give the repo a ⭐** and share it with someone studying for the RHCSA. It helps others find it.

## License

[GPL-3.0](./LICENSE)
