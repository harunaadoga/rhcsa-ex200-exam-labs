# Solutions - 08 Manage Users and Groups

> Run as root on node1.

## User/Group Creation

```bash
groupadd sharegroup

useradd -s /sbin/nologin haruna
useradd -G sharegroup umar
useradd -u 4444 -G sharegroup adoga

echo "haruna:persward" | chpasswd
echo "umar:persward" | chpasswd
echo "adoga:persward" | chpasswd

echo "adoga:perfect" | chpasswd

# Verify
id haruna                   # not in sharegroup
id umar                     # in sharegroup
id adoga                    # uid=4444, in sharegroup
grep haruna /etc/passwd     # shell is /sbin/nologin
su - adoga                  # from a normal user, test password: perfect
```

## Password Policies

### Minimum length 8
```bash
vi /etc/security/pwquality.conf
minlen = 8
```

### Maximum age 30 days
For new users:
```bash
vi /etc/login.defs
PASS_MAX_DAYS   30
```

For existing users (login.defs only applies to users created after the change):
```bash
chage -M 30 haruna
chage -M 30 umar
chage -M 30 adoga

# Verify
chage -l adoga              # Maximum number of days: 30
```

## Cleanup

```bash
gpasswd -d umar sharegroup
groupdel sharegroup
userdel -r haruna

# Verify
id umar                     # sharegroup gone
getent group sharegroup     # no output
id haruna                   # no such user
ls /home                    # no haruna directory
```
