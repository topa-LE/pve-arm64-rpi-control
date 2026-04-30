#!/bin/bash
set -e

echo "========================================"
echo "🌉 ENABLE vmbr0 (POST-BOOT STEP)"
echo "========================================"

echo
echo "⚠️ HINWEIS:"
echo "Dieses Script nur ausführen, wenn SSH stabil funktioniert!"

echo
read -p "Weiter mit vmbr0 Setup? (yes/no): " CONFIRM
[ "$CONFIRM" != "yes" ] && echo "Abgebrochen." && exit 1

echo
echo "📦 Pakete sicherstellen"
apt update
apt install -y ifupdown2 bridge-utils

echo
echo "💾 Backup erstellen"
cp /etc/network/interfaces /etc/network/interfaces.bak-vmbr0

echo
echo "🌉 vmbr0 setzen"

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
echo "🔍 CHECK"
cat /etc/network/interfaces

echo
echo "⚠️ JETZT REBOOTEN:"
echo "reboot"
echo
echo "========================================"
echo "✅ vmbr0 Script fertig"
echo "========================================"
