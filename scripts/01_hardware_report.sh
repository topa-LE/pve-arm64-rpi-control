#!/bin/bash
set -e

echo "========================================"
echo "🔍 PVE ARM64 RPI CONTROL - HARDWARE REPORT"
echo "========================================"

echo
echo "===== DATUM ====="
date

echo
echo "===== HOSTNAME ====="
hostnamectl || hostname

echo
echo "===== OS ====="
cat /etc/os-release || true

echo
echo "===== KERNEL ====="
uname -a

echo
echo "===== ARCHITEKTUR ====="
uname -m
dpkg --print-architecture || true

echo
echo "===== RASPBERRY PI MODELL ====="
cat /proc/device-tree/model 2>/dev/null || echo "Kein Raspberry Pi Modell gefunden"

echo
echo "===== CPU ====="
lscpu || true

echo
echo "===== RAM ====="
free -h || true

echo
echo "===== STORAGE ====="
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS,MODEL,SERIAL || lsblk

echo
echo "===== USB ====="
lsusb || true

echo
echo "===== PCI / NVME ====="
lspci 2>/dev/null || echo "lspci nicht verfügbar oder kein PCI Bus"

echo
echo "===== NETZWERK ====="
ip -br a || true
ip route || true

echo
echo "===== BOOT CONFIG ====="
if [ -f /boot/firmware/config.txt ]; then
  sed -n '1,220p' /boot/firmware/config.txt
elif [ -f /boot/config.txt ]; then
  sed -n '1,220p' /boot/config.txt
else
  echo "Keine config.txt gefunden"
fi

echo
echo "===== APT SOURCES ====="
grep -R "^deb " /etc/apt/sources.list /etc/apt/sources.list.d/ 2>/dev/null || true

echo
echo "========================================"
echo "✅ HARDWARE REPORT FERTIG"
echo "========================================"
