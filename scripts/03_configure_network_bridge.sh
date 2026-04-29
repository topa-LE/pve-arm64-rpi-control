#!/bin/bash
set -e

echo "========================================"
echo "🌉 PVE ARM64 RPI CONTROL - NETWORK BRIDGE"
echo "========================================"

echo
echo "🔍 ROOT CHECK"
if [ "$EUID" -ne 0 ]; then
  echo "❌ Script muss als root laufen!"
  exit 1
fi
echo "✅ Root OK"

echo
echo "📦 ifupdown2 prüfen/installieren"
apt update
apt install -y ifupdown2 bridge-utils net-tools

echo
echo "⚡ Boot-Wartezeit deaktivieren"
systemctl disable systemd-networkd-wait-online.service 2>/dev/null || true
systemctl mask systemd-networkd-wait-online.service 2>/dev/null || true

echo
echo "🛑 NetworkManager deaktivieren, falls vorhanden"
systemctl disable NetworkManager.service 2>/dev/null || true
systemctl stop NetworkManager.service 2>/dev/null || true

echo
echo "🌉 Persistente vmbr0 Bridge über eth0 schreiben"
cp /etc/network/interfaces "/etc/network/interfaces.bak-pve-arm64-rpi-control-$(date +%Y%m%d-%H%M%S)"

cat > /etc/network/interfaces <<'NETEOF'
auto lo
iface lo inet loopback

iface eth0 inet manual

auto vmbr0
iface vmbr0 inet dhcp
        bridge-ports eth0
        bridge-stp off
        bridge-fd 0

source /etc/network/interfaces.d/*
NETEOF

echo
echo "🔍 CHECK /etc/network/interfaces"
cat /etc/network/interfaces

echo
echo "✅ Bridge-Konfiguration geschrieben"
echo "ℹ️ Bitte danach rebooten, nicht live Netzwerk umstellen."
echo
echo "========================================"
echo "✅ NETWORK BRIDGE FERTIG"
echo "========================================"
