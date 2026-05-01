#!/bin/bash
set -e

echo "========================================"
echo "🌐 PVE ARM64 RPI CONTROL - SAFE LAN DHCP"
echo "========================================"

echo
echo "🔍 ROOT CHECK"
if [ "$EUID" -ne 0 ]; then
  echo "❌ Script muss als root laufen!"
  exit 1
fi
echo "✅ Root OK"

echo
echo "📦 Netzwerk-Basispakete installieren"
apt-get update
apt-get install -y ifupdown2 net-tools

echo
echo "⚡ Boot-Wartezeit deaktivieren"
systemctl disable systemd-networkd-wait-online.service 2>/dev/null || true
systemctl mask systemd-networkd-wait-online.service 2>/dev/null || true

echo
echo "🌐 Boot-sichere LAN-Konfiguration schreiben"
cp /etc/network/interfaces "/etc/network/interfaces.bak-pve-arm64-rpi-control-$(date +%Y%m%d-%H%M%S)" 2>/dev/null || true

cat > /etc/network/interfaces <<'NETEOF'
auto lo
iface lo inet loopback

allow-hotplug eth0
iface eth0 inet dhcp

source /etc/network/interfaces.d/*
NETEOF

echo
echo "🔍 CHECK /etc/network/interfaces"
cat /etc/network/interfaces

echo
echo "✅ SAFE LAN DHCP geschrieben"
echo "ℹ️ vmbr0 wird später separat gesetzt, wenn das Basissystem stabil bootet."
echo "========================================"
