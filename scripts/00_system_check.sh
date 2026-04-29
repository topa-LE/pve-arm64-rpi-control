#!/bin/bash
set -e

echo "========================================"
echo "🔍 PVE ARM64 RPI CONTROL - SYSTEM CHECK"
echo "========================================"

echo
echo "===== HOSTNAME ====="
hostnamectl || hostname

echo
echo "===== OS RELEASE ====="
cat /etc/os-release || true

echo
echo "===== KERNEL ====="
uname -a

echo
echo "===== ARCHITEKTUR ====="
dpkg --print-architecture || true
uname -m

echo
echo "===== CPU ====="
lscpu || true

echo
echo "===== RAM ====="
free -h || true

echo
echo "===== STORAGE ====="
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS,MODEL || lsblk

echo
echo "===== NETZWERK ====="
ip -br a || true

echo
echo "===== APT SOURCES ====="
grep -R "^deb " /etc/apt/sources.list /etc/apt/sources.list.d/ 2>/dev/null || true

echo
echo "========================================"
echo "✅ SYSTEM CHECK FERTIG"
echo "========================================"
