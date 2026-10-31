#!/bin/bash
# Mock exam grader for node1 (tasks 1-14). Run as root on node1.

PASS=0
FAIL=0
check() {
    if eval "$2" >/dev/null 2>&1; then
        echo "  PASS  $1"; PASS=$((PASS+1))
    else
        echo "  FAIL  $1"; FAIL=$((FAIL+1))
    fi
}
pw() {
    hash=$(awk -F: -v u="$1" '$1==u {print $2}' /etc/shadow)
    python3 -c 'import ctypes,ctypes.util,sys; l=ctypes.CDLL(ctypes.util.find_library("crypt")); l.crypt.restype=ctypes.c_char_p; r=l.crypt(sys.argv[1].encode(),sys.argv[2].encode()); sys.exit(0 if r and r.decode()==sys.argv[2] else 1)' "$2" "$hash"
}

[ "$(id -u)" -eq 0 ] || { echo "Run as root"; exit 1; }

echo "Task 1: Networking"
check "IP 192.168.70.10/24"       "ip -4 addr | grep -q 'inet 192.168.70.10/24'"
check "Gateway on 192.168.70.0/24"  "ip route | grep -q '^default via 192\.168\.70\.'"
check "DNS 192.168.70.5"          "grep -q '^nameserver 192.168.70.5' /etc/resolv.conf"

echo "Task 2: Hostname"
check "Hostname servera.rhcsa.home" "[ \"\$(hostnamectl hostname)\" = servera.rhcsa.home ]"

echo "Task 3: Repositories"
check "BaseOS repo configured"    "grep -rq 'repo.rhcsa.home/repo/BaseOS' /etc/yum.repos.d/"
check "AppStream repo configured" "grep -rq 'repo.rhcsa.home/repo/AppStream' /etc/yum.repos.d/"
check "Repos work"                "dnf -q makecache"

echo "Task 4: Users and groups"
check "Group teamgrp exists"      "getent group teamgrp"
check "james in teamgrp"          "id -nG james | grep -qw teamgrp"
check "olivia in teamgrp"         "id -nG olivia | grep -qw teamgrp"
check "emma not in teamgrp"       "id emma && ! id -nG emma | grep -qw teamgrp"
check "emma has nologin shell"    "getent passwd emma | grep -q 'nologin$'"
check "james password flamingo"   "pw james flamingo"
check "olivia password flamingo"  "pw olivia flamingo"
check "emma password flamingo"    "pw emma flamingo"

echo "Task 5: User with UID"
check "lucas UID 3456"            "[ \"\$(id -u lucas)\" = 3456 ]"
check "lucas password flamingo"   "pw lucas flamingo"

echo "Task 6: Password aging"
check "PASS_MAX_DAYS 25 in login.defs" "grep -Eq '^PASS_MAX_DAYS[[:space:]]+25$' /etc/login.defs"
for u in james olivia emma lucas; do
    check "$u max age 25 days"    "chage -l $u | grep Maximum | grep -q ': 25$'"
done

echo "Task 7: Find files"
check "daniel's files copied"     "ls /root/daniel-files/daniel_notes /root/daniel-files/daniel_report /root/daniel-files/daniel_data"

echo "Task 8: Collaborative directory"
check "/home/teamwork group teamgrp" "[ \"\$(stat -c %G /home/teamwork)\" = teamgrp ]"
check "/home/teamwork mode 2770"  "[ \"\$(stat -c %a /home/teamwork)\" = 2770 ]"

echo "Task 9: Web server"
check "httpd enabled"             "systemctl is-enabled httpd"
check "httpd running"             "systemctl is-active httpd"
check "Port 84 open in firewall"  "firewall-cmd --permanent --query-port=84/tcp"
check "page1.html served"         "curl -s http://localhost:84/page1.html | grep -q 'mock exam passed'"

echo "Task 10: Search text"
check "/root/ocean.txt correct"   "[ -s /root/ocean.txt ] && diff -q <(grep ocean /usr/share/dict/words) /root/ocean.txt"

echo "Task 11: Archive"
check "Archive is valid tar.gz"   "tar -tzf /backup/doc_backup.tar.gz | grep -q 'usr/share/doc'"

echo "Task 12: Cron job"
check "olivia cron every 4 min"   "crontab -l -u olivia | grep -q '^\*/4 \* \* \* \*.*logger.*Mock exam in progress'"

echo "Task 13: NTP"
check "chrony uses repo.rhcsa.home" "grep -Eq '^(server|pool)[[:space:]]+repo.rhcsa.home' /etc/chrony.conf"
check "chronyd enabled"           "systemctl is-enabled chronyd"

echo "Task 14: Autofs"
check "netuser1 UID 3001"         "[ \"\$(id -u netuser1)\" = 3001 ]"
check "netuser1 home /remotehome/netuser1" "getent passwd netuser1 | cut -d: -f6 | grep -qx /remotehome/netuser1"
check "autofs enabled"            "systemctl is-enabled autofs"
check "Home mounts over NFS"      "ls /remotehome/netuser1 && findmnt -n /remotehome/netuser1 | grep -q 'repo.rhcsa.home:/home/netuser1'"

echo
echo "Score: $PASS passed, $FAIL failed"
