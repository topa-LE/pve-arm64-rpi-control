#!/bin/bash
set -e

echo "========================================"
echo "📏 STEP 03 – EXPAND ROOT FILESYSTEM"
echo "========================================"

ROOT_PART=$(findmnt / -o SOURCE -n)
DISK="/dev/$(lsblk -no PKNAME "$ROOT_PART")"

echo "👉 ROOT PARTITION: $ROOT_PART"
echo "👉 DISK: $DISK"

echo
echo "📦 Pakete sicherstellen"
apt-get update
apt-get install -y cloud-guest-utils

echo
echo "📦 Partition erweitern"
growpart "$DISK" 1 || true

echo
echo "📦 Filesystem erweitern"
resize2fs "$ROOT_PART" || true

echo
echo "===== CHECK ====="
df -h /

echo
echo "========================================"
echo "✅ ROOTFS EXPANDED"
echo "========================================"
