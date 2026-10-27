# Solutions - 11 Manage Software - Flatpak (RHEL 10)

> Run as root on node1. Installing as root installs system-wide.
>
> On Rocky Linux or AlmaLinux you can still add the RHEL remote, but installing apps from it needs a Red Hat account (`podman login registry.redhat.io`). Flathub works on all three.

## Task 1: Configure Repositories

```bash
# 1.1 Install Flatpak
dnf install -y flatpak

# 1.2 Add Flathub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# 1.3 Add RHEL Flatpak repository
flatpak remote-add --if-not-exists rhel https://flatpaks.redhat.io/rhel.flatpakrepo

# 1.4 Verify
flatpak remotes             # flathub and rhel listed
```

## Task 2: Install & Manage Packages

```bash
# 2.1 Search
flatpak search firefox

# 2.2 Install from Flathub
flatpak install -y flathub org.mozilla.firefox

# 2.3 List installed apps
flatpak list --app

# 2.4 Update
flatpak update -y org.mozilla.firefox

# 2.5 Remove and clean unused runtimes
flatpak uninstall -y org.mozilla.firefox
flatpak uninstall --unused -y

# Verify
flatpak list --app          # firefox gone
flatpak list --runtime      # unused runtimes gone
```
