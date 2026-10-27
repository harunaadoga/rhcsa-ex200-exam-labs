#!/bin/bash
# Mock exam: repo server setup. Run as root on repo.rhcsa.home.
# Needs: full DVD ISO (RHEL, Rocky or AlmaLinux) attached as CD/DVD, internet access (for container images).
set -e

# Hostnames
hostnamectl set-hostname repo.rhcsa.home
cat >> /etc/hosts << 'EOF'
192.168.70.5   repo.rhcsa.home repo
192.168.70.10  node1.rhcsa.home node1 servera.rhcsa.home
192.168.70.20  node2.rhcsa.home node2
EOF

# Copy BaseOS and AppStream from the ISO
mkdir -p /mnt/iso /var/www/html/repo
mount /dev/sr0 /mnt/iso
cp -r /mnt/iso/BaseOS /mnt/iso/AppStream /var/www/html/repo/
umount /mnt/iso

# Use the copied repos on this server
cat > /etc/yum.repos.d/local.repo << 'EOF'
[local-baseos]
name=local-baseos
baseurl=file:///var/www/html/repo/BaseOS/
gpgcheck=0
[local-appstream]
name=local-appstream
baseurl=file:///var/www/html/repo/AppStream/
gpgcheck=0
EOF
dnf install -y httpd nfs-utils chrony podman httpd-tools

# Web server for the repos
restorecon -R /var/www/html
systemctl enable --now httpd

# NFS homes: netuser1 (mock exam task 14), bobby (lab 05)
useradd -u 2060 bobby
echo "bobby:hoppy" | chpasswd
echo "/home/bobby  192.168.70.0/24(rw,sync)" >> /etc/exports
useradd -u 3001 netuser1
echo "netuser1:flamingo" | chpasswd
echo "/home/netuser1  192.168.70.0/24(rw,sync)" >> /etc/exports
systemctl enable --now nfs-server
exportfs -ra

# NTP server (task 13)
echo "allow 192.168.70.0/24" >> /etc/chrony.conf
echo "local stratum 10" >> /etc/chrony.conf
systemctl enable chronyd
systemctl restart chronyd

# Container registry, login rhcsa / Passw0rd (task 21)
mkdir -p /opt/registry/auth /opt/registry/data
htpasswd -Bbc /opt/registry/auth/htpasswd rhcsa Passw0rd
podman run -d --name registry --restart=always -p 5000:5000 \
  -v /opt/registry/data:/var/lib/registry:Z \
  -v /opt/registry/auth:/auth:Z \
  -e REGISTRY_AUTH=htpasswd \
  -e REGISTRY_AUTH_HTPASSWD_REALM="RHCSA Registry" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  docker.io/library/registry:2
systemctl enable podman-restart.service

# Image for task 21
mkdir -p /root/filebox
cat > /root/filebox/Containerfile << 'EOF'
FROM registry.access.redhat.com/ubi9/ubi-minimal
CMD ["sleep", "infinity"]
EOF
podman build -t repo.rhcsa.home:5000/rhcsa/filebox:latest /root/filebox
podman login --tls-verify=false -u rhcsa -p Passw0rd repo.rhcsa.home:5000
podman push --tls-verify=false repo.rhcsa.home:5000/rhcsa/filebox:latest

# Containerfile for lab 10
mkdir -p /var/www/html/containers
cat > /var/www/html/containers/Containerfile << 'EOF'
FROM registry.access.redhat.com/ubi9/ubi
RUN dnf install -y httpd && dnf clean all
RUN echo "RHCSA container works" > /var/www/html/index.html
EXPOSE 80
CMD ["httpd", "-DFOREGROUND"]
EOF
restorecon -R /var/www/html/containers

# Firewall
firewall-cmd --permanent --add-service={http,nfs,mountd,rpc-bind,ntp}
firewall-cmd --permanent --add-port=5000/tcp
firewall-cmd --reload

echo "repo server ready"
