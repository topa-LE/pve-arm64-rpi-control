#!/bin/bash
set -e

echo "========================================"
echo "🔐 PREPARE PVE IMAGE SAFE"
echo "SSH + ROOT PASSWORD"
echo "========================================"

if [ "$EUID" -ne 0 ]; then
  echo "❌ Bitte als root ausführen."
  exit 1
fi

echo
echo "===== VERFÜGBARE LAUFWERKE ====="
lsblk -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINTS,MODEL,TRAN

echo
echo "⚠️ WICHTIG:"
echo "Bitte die Debian-Root-Partition angeben, z. B.: /dev/sdb1"
echo "NIEMALS die Systempartition verwenden."

echo
read -rp "Root-Partition eingeben: " PART

if [ ! -b "$PART" ]; then
  echo "❌ $PART ist kein gültiges Blockdevice."
  exit 1
fi

ROOT_DEV=$(findmnt -n -o SOURCE /)
if [ "$PART" = "$ROOT_DEV" ]; then
  echo "❌ Abbruch: $PART ist die laufende Systempartition!"
  exit 1
fi

FSTYPE=$(lsblk -no FSTYPE "$PART" | head -n1)
if [ "$FSTYPE" != "ext4" ]; then
  echo "❌ Abbruch: $PART ist kein ext4 RootFS."
  echo "Gefunden: $FSTYPE"
  exit 1
fi

MOUNT="/mnt/pve-root"
mkdir -p "$MOUNT"

if mountpoint -q "$MOUNT"; then
  umount "$MOUNT"
fi

echo
echo "📦 Mounten: $PART → $MOUNT"
mount "$PART" "$MOUNT"

cleanup() {
  sync || true
  umount "$MOUNT/dev/pts" 2>/dev/null || true
  umount "$MOUNT/dev" 2>/dev/null || true
  umount "$MOUNT/proc" 2>/dev/null || true
  umount "$MOUNT/sys" 2>/dev/null || true
  umount "$MOUNT" 2>/dev/null || true
}
trap cleanup EXIT

if [ ! -f "$MOUNT/etc/os-release" ]; then
  echo "❌ Kein Linux RootFS erkannt."
  exit 1
fi

echo
echo "===== OS CHECK ====="
cat "$MOUNT/etc/os-release"

if ! grep -qi "debian" "$MOUNT/etc/os-release"; then
  echo "❌ Kein Debian RootFS erkannt."
  exit 1
fi

echo
echo "===== ARCH CHECK ====="
ARCH_INFO=$(file "$MOUNT/bin/bash")
echo "$ARCH_INFO"

if ! echo "$ARCH_INFO" | grep -qi "aarch64"; then
  echo "❌ Kein ARM64/aarch64 System erkannt!"
  exit 1
fi

echo
echo "📦 Chroot vorbereiten"
mount --bind /dev "$MOUNT/dev"
mount --bind /dev/pts "$MOUNT/dev/pts"
mount -t proc proc "$MOUNT/proc"
mount -t sysfs sys "$MOUNT/sys"

echo
echo "🌐 DNS setzen"
rm -f "$MOUNT/etc/resolv.conf"
cat > "$MOUNT/etc/resolv.conf" <<DNS
nameserver 1.1.1.1
nameserver 8.8.8.8
DNS

echo
echo "📦 openssh-server installieren"
chroot "$MOUNT" apt-get update
chroot "$MOUNT" env DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server

echo
echo "🔧 SSH Service aktivieren"
chroot "$MOUNT" systemctl enable ssh

echo
echo "🔧 Root Passwort setzen: pimox"
HASH=$(openssl passwd -6 pimox)
sed -i "s|^root:[^:]*|root:$HASH|" "$MOUNT/etc/shadow"

echo
echo "🔧 SSH Root Login erlauben"
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' "$MOUNT/etc/ssh/sshd_config"
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' "$MOUNT/etc/ssh/sshd_config"

grep -q "^PermitRootLogin" "$MOUNT/etc/ssh/sshd_config" || echo "PermitRootLogin yes" >> "$MOUNT/etc/ssh/sshd_config"
grep -q "^PasswordAuthentication" "$MOUNT/etc/ssh/sshd_config" || echo "PasswordAuthentication yes" >> "$MOUNT/etc/ssh/sshd_config"

echo
echo "🔧 Hostname setzen"
echo "pve" > "$MOUNT/etc/hostname"

echo
echo "🔧 /etc/hosts setzen"
cat > "$MOUNT/etc/hosts" <<HOSTS
127.0.0.1 localhost
127.0.1.1 pve

::1 localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
HOSTS

echo
echo "🔧 SSH Host Keys vorbereiten"
chroot "$MOUNT" ssh-keygen -A

echo
echo "✅ IMAGE PREP FERTIG"
echo "USB/NVMe kann jetzt in den Raspberry Pi."
