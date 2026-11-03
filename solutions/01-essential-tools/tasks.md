# Solutions - 01 Understand and Use Essential Tools

> Run as root on node1 unless stated otherwise.

## Task 1: Text Search & Archive

### 1.1 Find "Listen" and save output
```bash
dnf install -y httpd        # only if httpd.conf doesn't exist yet
grep Listen /etc/httpd/conf/httpd.conf > /root/web.txt

# Verify
cat /root/web.txt
```

### 1.2 gzip-compressed tar archive of /etc
```bash
man tar                     # search with /gzip  ->  -z, --gzip
mkdir -p /vaults
tar -czf /vaults/etc_vault.tar.gz /etc

# Verify
ls -lh /vaults/etc_vault.tar.gz
file /vaults/etc_vault.tar.gz
tar -tzf /vaults/etc_vault.tar.gz | head
```

## Task 2: File Links

```bash
mkdir -p /shorts
cd /shorts
touch file_a
ln -s file_a file_b         # soft link
ln file_a file_c            # hard link

# Verify
ls -li /shorts              # file_a and file_c share the same inode number
                            # file_b shows file_b -> file_a
echo "link test" > file_a
cat file_b file_c           # both show "link test"
```

## Task 3: Find

### 3.1 Files in /usr between 3MB and 10MB
```bash
mkdir -p /bigfiles
find /usr -type f -size +3M -size -10M -exec cp {} /bigfiles/ \;

# Verify
ls -lh /bigfiles
```
> Note: `find` rounds sizes up to whole units, so `-size -10M` matches files up to 9MB. For a stricter upper limit use `-size -10240k`.

### 3.2 Files in /etc modified more than 120 days ago
```bash
mkdir -p /var/tmp/twenty
find /etc -type f -mtime +120 -exec cp {} /var/tmp/twenty/ \;

# Verify
ls -l /var/tmp/twenty | head
```

### 3.3 Files owned by user hadoga
```bash
mkdir /root/h-files
find / -type f -user hadoga -exec cp {} /root/h-files/ \;

# Verify
ls -la /root/h-files
```

### 3.4 Absolute paths of httpd.conf
```bash
find / -type f -name httpd.conf > /root/httpd-paths.txt

# Verify
cat /root/httpd-paths.txt
```

## Task 4: Remote Access & File Permissions

### 4.1 SSH into node2 as hadoga
```bash
ssh hadoga@node2
```

### 4.2 to 4.4 Copy fstab, set owner to root, remove execute
> hadoga needs sudo rights (member of `wheel`) because only root can change ownership.
```bash
sudo cp /etc/fstab /var/tmp/
sudo chown root:root /var/tmp/fstab
sudo chmod a-x /var/tmp/fstab

# Verify
ls -l /var/tmp/fstab        # owner root, no x anywhere, e.g. -rw-r--r--
```
