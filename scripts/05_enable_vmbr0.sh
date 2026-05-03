#!/bin/bash
set -e

echo "========================================"
echo "🌉 STEP 05 - VMBR0 FINAL CONFIG"
echo "========================================"

BRIDGE="${BRIDGE:-vmbr0}"

# Skip wenn vmbr0 bereits aktiv ist
if ip -4 addr show "$BRIDGE" 2>/dev/null | grep -q "inet "; then
  echo "✅ $BRIDGE ist bereits aktiv – überspringe STEP 05"
  ip -br a
  ip route
  exit 0
fi

IFACE="${IFACE:-$(ip -br link | awk '$1 !~ /^(lo|vmbr|wlan|br|docker|veth)/ {print $1; exit}')}"

if [ -z "$IFACE" ]; then
  echo "❌ Kein aktives LAN-Interface erkannt!"
  ip -br a
  ip route
  exit 1
fi

CURRENT_IP="$(ip -4 addr show "$IFACE" | grep -oP '(?<=inet\s)\d+(\.\d+){3}/\d+' | head -n1 || true)"
CURRENT_GW="$(ip route | awk '/default/ && $0 ~ /'"$IFACE"'/ {print $3; exit}' || true)"

if [ -z "$CURRENT_IP" ] || [ -z "$CURRENT_GW" ]; then
  echo "❌ Konnte aktuelle IP/Gateway nicht erkennen!"
  ip -br a
  ip route
  exit 1
fi

echo "✅ Erkanntes LAN-Interface: $IFACE"
echo "✅ Bridge: $BRIDGE"
echo "✅ Aktuelle IP: $CURRENT_IP"
echo "✅ Gateway: $CURRENT_GW"

echo
echo "📦 Pakete sicherstellen"
apt-get update
apt-get install -y ifupdown2 bridge-utils

echo
echo "🛑 Konflikt-Stacks deaktivieren"

systemctl stop systemd-networkd 2>/dev/null || true
systemctl disable systemd-networkd 2>/dev/null || true
systemctl mask systemd-networkd 2>/dev/null || true

systemctl stop systemd-networkd.socket 2>/dev/null || true
systemctl disable systemd-networkd.socket 2>/dev/null || true
systemctl mask systemd-networkd.socket 2>/dev/null || true

systemctl disable --now NetworkManager 2>/dev/null || true
systemctl mask NetworkManager 2>/dev/null || true

if [ -d /etc/netplan ]; then
  mkdir -p /root/netplan-backup
  mv /etc/netplan/*.yaml /root/netplan-backup/ 2>/dev/null || true
fi

echo
echo "📦 Backup /etc/network/interfaces"
cp /etc/network/interfaces "/etc/network/interfaces.bak-vmbr0-$(date +%Y%m%d-%H%M%S)" 2>/dev/null || true

echo
echo "🌉 Schreibe finale vmbr0 Config"

cat > /etc/network/interfaces <<NETEOF
auto lo
iface lo inet loopback

iface ${IFACE} inet manual

auto ${BRIDGE}
iface ${BRIDGE} inet static
    address ${CURRENT_IP}
    gateway ${CURRENT_GW}
    bridge-ports ${IFACE}
    bridge-stp off
    bridge-fd 0

source /etc/network/interfaces.d/*
NETEOF

echo
echo "🔍 CHECK /etc/network/interfaces"
cat /etc/network/interfaces

echo
echo "========================================"
echo "✅ VMBR0 CONFIG GESCHRIEBEN"
echo "⚠️ KEIN LIVE SWITCH"
echo "➡️ Bitte jetzt rebooten:"
echo "reboot"
echo "========================================"
