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
echo "⚙️ NON-INTERACTIVE MODE AKTIVIEREN"
export DEBIAN_FRONTEND=noninteractive

echo
echo "📦 DEBCONF PRESEED (POSTFIX + ZFS)"
echo "postfix postfix/main_mailer_type string No configuration" | debconf-set-selections
echo "postfix postfix/mailname string localhost" | debconf-set-selections
echo "zfs-dkms zfs-dkms/note string" | debconf-set-selections
echo "zfs-dkms zfs-dkms/enable boolean true" | debconf-set-selections

echo
echo "🔄 APT UPDATE"
apt update

echo
echo "📦 Installiere Basis Tools (verhindert Dialoge)"
apt install -y dialog apt-utils

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
