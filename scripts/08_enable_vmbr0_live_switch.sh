#!/bin/bash
set -e

echo "========================================"
echo "🌉 ENABLE VMBR0 LIVE SWITCH"
echo "========================================"

IFACE="${IFACE:-eth0}"
BRIDGE="${BRIDGE:-vmbr0}"

echo
echo "🔎 Prüfe bestehenden Bridge-Zustand"

if ip -4 addr show "$BRIDGE" 2>/dev/null | grep -q "inet "; then
  echo "✅ $BRIDGE hat bereits eine IPv4-Adresse"
  echo "ℹ️ Live-Switch wurde bereits durchgeführt – Schritt wird übersprungen"
  ip -br a
  ip route
  exit 0
fi

CURRENT_IP="$(ip -4 addr show "$IFACE" | grep -oP '(?<=inet\s)\d+(\.\d+){3}/\d+' | head -n1 || true)"
CURRENT_GW="$(ip route | awk '/default/ && $0 ~ /'"$IFACE"'/ {print $3; exit}' || true)"

if [ -z "$CURRENT_IP" ] || [ -z "$CURRENT_GW" ]; then
  echo "❌ Konnte aktuelle IP/Gateway nicht automatisch erkennen!"
  echo "Interface: $IFACE"
  ip -br a
  ip route
  exit 1
fi

echo "✅ Aktuelle IP: $CURRENT_IP"
echo "✅ Gateway: $CURRENT_GW"

echo
echo "🛑 NetworkManager deaktivieren"
systemctl disable --now NetworkManager 2>/dev/null || true
systemctl mask NetworkManager 2>/dev/null || true

echo
echo "🌉 vmbr0 aktivieren"
ifup "$BRIDGE" || true

sleep 2

echo
echo "🧹 IP von $IFACE entfernen"
ip addr flush dev "$IFACE" || true

echo
echo "🔁 Netzwerk reload"
ifreload -a || true

echo
echo "===== CHECK ====="
ip -br a
ip route

echo
echo "✅ VMBR0 LIVE SWITCH FERTIG"
