#!/bin/bash
set -e

echo "========================================"
echo "📦 INSTALL PIMOX / PROXMOX VE ARM64"
echo "========================================"

if [ "$EUID" -ne 0 ]; then
  echo "❌ Script muss als root laufen!"
  exit 1
fi

echo
echo "🔄 APT UPDATE"
apt update

echo
echo "🚀 Installiere proxmox-ve"
apt install -y proxmox-ve

echo
echo "🔄 Upgrade nach PVE Installation"
apt update
apt upgrade -y

echo
echo "🧹 Cleanup"
apt autoremove -y

echo
echo "✅ PVE Installation fertig"
pveversion || true
