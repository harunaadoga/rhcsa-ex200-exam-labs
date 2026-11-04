#!/bin/bash
# Mock exam: node1 prep. Run as root on node1 after setup-repo.sh.
set -e

# Hostnames
hostnamectl set-hostname node1.rhcsa.home
# Remove the lab lines added during setup, so they aren't listed twice
sed -i '/rhcsa\.home/d' /etc/hosts
cat >> /etc/hosts << 'EOF'
192.168.70.5   repo.rhcsa.home repo
192.168.70.10  node1.rhcsa.home node1 servera.rhcsa.home
192.168.70.20  node2.rhcsa.home node2
EOF

# Temporary repos so this script can install packages (removed at the end)
cat > /etc/yum.repos.d/prep.repo << 'EOF'
[prep-baseos]
name=prep-baseos
baseurl=http://repo.rhcsa.home/repo/BaseOS/
gpgcheck=0
[prep-appstream]
name=prep-appstream
baseurl=http://repo.rhcsa.home/repo/AppStream/
gpgcheck=0
EOF
dnf install -y httpd words

# Task 7: user daniel with files in a few places
useradd daniel
touch /tmp/daniel_notes /var/tmp/daniel_report /opt/daniel_data
chown daniel /tmp/daniel_notes /var/tmp/daniel_report /opt/daniel_data

# Task 9: broken web server on port 84
sed -i 's/^Listen 80$/Listen 84/' /etc/httpd/conf/httpd.conf
echo "mock exam passed" > /root/page1.html
mv /root/page1.html /var/www/html/page1.html
chmod 600 /var/www/html/page1.html
systemctl enable httpd

# Remove the temporary repos
rm -f /etc/yum.repos.d/prep.repo

# Turn off the node's own repos, like the real exam. Only the exam repos should work.
if command -v subscription-manager >/dev/null; then
    subscription-manager config --rhsm.manage_repos=0
fi
mkdir -p /root/repos-backup
mv /etc/yum.repos.d/*.repo /root/repos-backup/ 2>/dev/null || true
dnf clean all

# Task 1: move node1 off the lab network. The exam starts on the console.
CON=$(nmcli -g NAME,TYPE con show --active | awk -F: '$2 ~ /ethernet/ {print $1; exit}')
if [ -z "$CON" ]; then
    echo "No active wired connection found on node1."
    exit 1
fi
nmcli con mod "$CON" ipv4.method manual ipv4.addresses 10.0.0.10/24 ipv4.gateway "" ipv4.dns ""

# Save the grader now, while there is internet (node1 loses it in task 1)
curl -sf -o /root/grade-node1.sh https://raw.githubusercontent.com/harunaadoga/rhcsa-ex200-exam-labs/main/mock-exam/grade-node1.sh

echo "node1 ready for the mock exam"
echo "node1 leaves the lab network in 10 seconds. Continue on node1's VM console."
systemd-run --on-active=10 /usr/bin/nmcli con up "$CON" >/dev/null 2>&1
