# 02 - Create Simple Shell Scripts

All tasks on node1, as root.

## Task 1: Size-Based File Search
1.1 Create a script `/root/sized_files.sh` that finds files in /usr larger than 30KB but smaller than 50KB.
1.2 The script must save the results to `/root/sized_files.txt`.

## Task 2: Conditional Script
2.1 Create `/root/career.sh` that:
   - Outputs `Yes, I'm a Systems Engineer.` when run with `./career.sh me`
   - Outputs `Okay, they do cloud engineering.` when run with `./career.sh they`
   - Outputs `Usage: ./career.sh me|they` for any other argument, or no argument

## Task 3: Users and Groups Scripts
3.1 Create a script `/root/users.sh` that creates these users (username:UID:supplementary groups) and their groups:
   - `maryam:2030:hpc_admin,hpc_managers`
   - `adam:2040:sysadmin`
   - `jacob:2050:hpc_admin`

3.2 Create a script `/root/passwords.sh` that sets the password of maryam, adam and jacob to `Password@1`.
