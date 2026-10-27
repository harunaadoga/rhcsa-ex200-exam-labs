# Solutions - 07 Manage Basic Networking

> Run as root on node1. Do Task 3 from the VM console, not over SSH: changing the IP drops your SSH session.

## Task 1: Network service at boot

```bash
systemctl enable --now NetworkManager

# Verify
systemctl is-enabled NetworkManager
systemctl is-active NetworkManager
```

## Task 2: Firewall

```bash
systemctl enable --now firewalld

firewall-cmd --permanent --add-service=ssh
firewall-cmd --permanent --add-service=http
firewall-cmd --reload

# Verify
firewall-cmd --list-services
```

## Task 3: Static IP, DNS, Hostname

### Find the connection name
```bash
nmcli con show              # note the NAME, e.g. "enp1s0"
```

### Configure static IP
```bash
nmcli con mod "enp1s0" ipv4.method manual \
  ipv4.addresses 172.16.1.10/24 \
  ipv4.gateway 172.16.1.1 \
  ipv4.dns 172.16.1.1 \
  ipv4.dns-search rhel.server.com \
  connection.autoconnect yes

nmcli con up "enp1s0"
```
> Replace `enp1s0` with your connection name.

### Set hostname
```bash
hostnamectl set-hostname node5.rhcsa
```

### Verify
```bash
ip addr show                # 172.16.1.10/24
ip route                    # default via 172.16.1.1
cat /etc/resolv.conf        # nameserver 172.16.1.1, search rhel.server.com
hostname                    # node5.rhcsa
nmcli con show "enp1s0" | grep ipv4
```

### Final check
```bash
reboot
ip addr show
hostname
firewall-cmd --list-services
```
