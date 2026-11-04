#!/bin/bash
# Mock exam grader for node2 (tasks 15-21). Run as root on node2.

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
between() {
    [ "$1" -ge "$2" ] && [ "$1" -le "$3" ]
}

[ "$(id -u)" -eq 0 ] || { echo "Run as root"; exit 1; }

echo "Task 15: Root password"
check "root password flamingo"    "pw root flamingo"

echo "Task 16: Resize logical volume"
LV_MB=$(lvs --noheadings --units m --nosuffix -o lv_size datavg/datalv 2>/dev/null | cut -d. -f1 | tr -d ' ')
FS_MB=$(tune2fs -l /dev/datavg/datalv 2>/dev/null | awk '/^Block count:/ {c=$3} /^Block size:/ {s=$3} END {print int(c*s/1048576)}')
check "datalv is 280-320MB"       "between ${LV_MB:-0} 280 320"
check "Filesystem resized too"    "between ${FS_MB:-0} 270 320"
check "/data still mounted"       "findmnt /data"

echo "Task 17: Repositories"
check "BaseOS repo configured"    "grep -rq 'repo.rhcsa.home/repo/BaseOS' /etc/yum.repos.d/"
check "AppStream repo configured" "grep -rq 'repo.rhcsa.home/repo/AppStream' /etc/yum.repos.d/"

echo "Task 18: New logical volume"
check "VG finance PE size 16MB"   "vgs --noheadings --units m -o vg_extent_size finance | grep -q '16.00m'"
check "LV payroll has 40 extents" "lvdisplay finance/payroll | grep -Eq 'Current LE +40$'"
check "/mnt/payroll is ext3"      "[ \"\$(findmnt -no FSTYPE /mnt/payroll)\" = ext3 ]"
check "/mnt/payroll in fstab"     "grep -q '/mnt/payroll' /etc/fstab"

echo "Task 19: Swap"
NEW_SWAP=""
for dev in $(swapon --noheadings --show=NAME); do
    size=$(( $(blockdev --getsize64 "$dev") / 1048576 ))
    if between "$size" 500 525; then NEW_SWAP=$dev; fi
done
check "512MB swap active"         "[ -n \"$NEW_SWAP\" ]"
check "Swap in fstab"             "grep -Eq \"(\$(blkid -s UUID -o value $NEW_SWAP)|$NEW_SWAP)[[:space:]].*swap\" /etc/fstab"

echo "Task 20: Tuning profile"
check "Recommended profile active" "tuned-adm active | grep -q \"\$(tuned-adm recommend)\""

# Task 21 is graded for your OS version. To grade the other one: EXAM=9 bash /root/grade-node2.sh
MAJOR=${EXAM:-$(. /etc/os-release; echo "${VERSION_ID%%.*}")}
if [ "$MAJOR" -ge 10 ]; then
    echo "Task 21b: Flatpak (RHEL 10)"
    check "flatpak installed"           "rpm -q flatpak"
    check "flathub remote, system-wide" "flatpak remotes --system --columns=name | grep -qx flathub"
    check "Firefox installed, system-wide" "flatpak list --system --app --columns=application | grep -qx org.mozilla.firefox"
else
    echo "Task 21a: Rootless container (RHEL 9)"
    DEVOPS_UID=$(id -u devops)
    # Run from / so podman doesn't fail on root's home directory
    podman_devops() {
        (cd / && runuser -u devops -- env XDG_RUNTIME_DIR=/run/user/$DEVOPS_UID podman "$@")
    }
    check "Linger enabled for devops" "loginctl show-user devops -p Linger | grep -q yes"
    check "Service file exists"       "[ -f /home/devops/.config/systemd/user/container-filebox.service ]"
    check "Service enabled"           "ls /home/devops/.config/systemd/user/default.target.wants/container-filebox.service"
    check "filebox running"           "podman_devops ps --format '{{.Names}}' | grep -qx filebox"
    check "/srv/uploads -> /opt/outbox" "podman_devops inspect filebox --format '{{range .Mounts}}{{.Source}}:{{.Destination}} {{end}}' | grep -q '/srv/uploads:/opt/outbox'"
    check "/srv/reports -> /opt/inbox"  "podman_devops inspect filebox --format '{{range .Mounts}}{{.Source}}:{{.Destination}} {{end}}' | grep -q '/srv/reports:/opt/inbox'"
fi

echo
echo "Score: $PASS passed, $FAIL failed"
