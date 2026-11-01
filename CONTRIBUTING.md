# Contributing to RHCSA EX200 Exam Labs

Thanks for helping make this the best free RHCSA practice resource. Every fix, new task and better solution helps someone pass.

## Ways to Contribute

- **Report a problem:** a wrong command, a broken link, a task that doesn't work on RHEL, Rocky Linux or AlmaLinux 9 or 10. [Open an issue](https://github.com/harunaadoga/rhcsa-ex200-exam-labs/issues/new).
- **Fix something:** typos, unclear wording, incorrect solutions.
- **Add tasks:** new practice tasks for an existing objective, with a matching solution.
- **Share your experience:** passed the exam using these labs? Tell us in an issue. It helps others.

## Ground Rules

- **No exam dumps.** Never submit real exam questions or anything covered by the Red Hat exam NDA. Write original tasks based on the [public exam objectives](https://www.redhat.com/en/services/training/ex200-red-hat-certified-system-administrator-rhcsa-exam).
- **Keep solutions simple.** Use standard commands an exam candidate would type. No clever one-liners or extra tools.
- **Test before you submit.** Run every task and solution on a clean RHEL, Rocky Linux or AlmaLinux VM and check it survives a reboot.


## How to Submit a Change

### 1. Fork the repo
Click **Fork** at the top right of the repo page. This creates your own copy.

### 2. Clone your fork
```bash
git clone https://github.com/<your-username>/rhcsa-ex200-exam-labs.git
cd rhcsa-ex200-exam-labs
```

### 3. Create a branch
Use a short name that describes the change:
```bash
git checkout -b fix-lvm-solution
```

### 4. Make your changes
Follow the existing structure:
```
exam_objectives/<NN-objective>/tasks.md   # tasks only, no answers
solutions/<NN-objective>/tasks.md         # matching solutions
mock-exam/                                # mock exam files
```

Task format:
~~~markdown
## Task 1: Short Title
1.1 What the candidate must do, with exact names, sizes and paths.
~~~

Solution format:
~~~markdown
### 1.1 Short title
```bash
command

# Verify
command that proves it worked
```
~~~

Every solution needs a **Verify** step.

### 5. Commit and push to your fork
```bash
git add .
git commit -m "Fix swap fstab entry in 04 solution"
git push origin fix-lvm-solution
```

### 6. Open a pull request
Go to your fork on GitHub and click **Compare & pull request**. In the description, say:
- what you changed and why
- which distro and version you tested on (e.g. Rocky Linux 10)

The maintainer will review it and either merge it or reply with feedback.

## Keeping Your Fork Up to Date

Before starting new work:
```bash
git remote add upstream https://github.com/harunaadoga/rhcsa-ex200-exam-labs.git
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

## Questions

Ask in [Discussions](https://github.com/harunaadoga/rhcsa-ex200-exam-labs/discussions), or in the comments of any video on the [YouTube playlist](https://www.youtube.com/playlist?list=PLiI_-JOspy6FuSPXSipE0xE4oC2XXYyuI).
