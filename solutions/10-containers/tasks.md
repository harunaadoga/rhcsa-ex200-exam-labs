# Solutions - 10 Manage Containers (RHEL 9)

## Prep (as root on node2)

```bash
dnf install -y container-tools

mkdir -p /opt/user_files
chown haruna:haruna /opt/user_files

loginctl enable-linger haruna           # user services start at boot without login

firewall-cmd --permanent --add-port=8000/tcp
firewall-cmd --reload
```

## Task 1: Build Image (as haruna)

Log in with SSH, not `su`. Rootless podman and `systemctl --user` need a real login session.
```bash
ssh haruna@node2

mkdir ~/web && cd ~/web
curl -O http://repo.rhcsa.home/containers/Containerfile
podman build -t web_image .

# Verify
podman images               # localhost/web_image
```

## Task 2: Rootless Container as a Systemd Service (as haruna)

### Run the container
```bash
podman run -d --name haruna_web -p 8000:80 \
  -v /opt/user_files:/opt/userfiles:Z web_image

# Verify
podman ps
curl http://localhost:8000
```

### Create the systemd service
```bash
mkdir -p ~/.config/systemd/user
cd ~/.config/systemd/user
podman generate systemd --name haruna_web --files --new
```
> On RHEL 9 this prints a deprecation warning. Ignore it, the unit file is still created.

`--new` makes the service create the container itself, so remove the one you started:
```bash
podman stop haruna_web
podman rm haruna_web

systemctl --user daemon-reload
systemctl --user enable --now container-haruna_web.service

# Verify
systemctl --user status container-haruna_web.service
podman ps
curl http://localhost:8000
```

## Final Check

```bash
# as root
reboot

# after reboot
ssh haruna@node2
podman ps                   # haruna_web is running
curl http://localhost:8000
```
