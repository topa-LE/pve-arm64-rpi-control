#!/bin/bash
set -e

echo "========================================"
echo "🌉 ENABLE VMBR0 LIVE SWITCH"
echo "========================================"

if [ "$EUID" -ne 0 ]; then
  echo "❌ Script muss als root laufen!"
  exit 1
fi

IFACE="${IFACE:-eth0}"

echo
echo "🛑 NetworkManager deaktivieren (RaspOS Fix)"
systemctl disable --now NetworkManager 2>/dev/null || true
systemctl mask NetworkManager 2>/dev/null || true
systemctl daemon-reload

CURRENT_CIDR=$(ip -4 -o addr show dev "$IFACE" | awk '{print $4}' | head -n1)
CURRENT_IP=$(echo "$CURRENT_CIDR" | cut -d/ -f1)
GATEWAY=$(ip route | awk '/default/ {print $3; exit}')

if [ -z "$CURRENT_CIDR" ] || [ -z "$CURRENT_IP" ] || [ -z "$GATEWAY" ]; then
  echo "❌ Konnte aktuelle IP/Gateway nicht automatisch erkennen!"
  echo "Interface: $IFACE"
  ip -br a
  ip route
  exit 1
fi

echo "✅ Interface: $IFACE"
echo "✅ Aktuelle IP: $CURRENT_CIDR"
echo "✅ Gateway: $GATEWAY"

echo
echo "💾 Backup /etc/network/interfaces"
cp /etc/network/interfaces "/root/interfaces.pre-vmbr0.$(date +%F-%H%M%S)"

echo
echo "🌉 Schreibe vmbr0 Konfiguration"

cat > /etc/network/interfaces <<NETEOF
auto lo
iface lo inet loopback

auto $IFACE
iface $IFACE inet manual

auto vmbr0
iface vmbr0 inet static
    address $CURRENT_CIDR
    gateway $GATEWAY
    bridge-ports $IFACE
    bridge-stp off
    bridge-fd 0

source /etc/network/interfaces.d/*
NETEOF

echo
echo "===== CONFIG CHECK ====="
cat /etc/network/interfaces

echo
echo "🚀 Live Switch starten"
ifup vmbr0
sleep 2

echo
echo "🧹 Alte IP von $IFACE entfernen"
ip addr flush dev "$IFACE"
sleep 2

echo
echo "🔄 Netzwerk neu laden"
ifreload -a
sleep 2

echo
echo "===== CHECK ====="
ip -br a
ip route

echo
echo "🔍 FINAL CHECK vmbr0"

if ip -br a | grep -q "vmbr0[[:space:]].*UP.*$CURRENT_IP"; then
  echo "✅ vmbr0 aktiv mit IP $CURRENT_IP"
else
  echo "❌ vmbr0 NICHT korrekt aktiv – Abbruch!"
  ip -br a
  ip route
  exit 1
fi

if ip -4 -o addr show dev "$IFACE" | grep -q "$CURRENT_IP"; then
  echo "❌ $IFACE hat noch die alte IP $CURRENT_IP – Abbruch!"
  ip -br a
  exit 1
else
  echo "✅ $IFACE hat keine alte IP mehr"
fi

echo
echo "✅ vmbr0 Live Switch fertig"
echo "⚠️ Danach Reboot-Test ausführen!"
