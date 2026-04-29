#!/bin/bash
set -e

echo "========================================"
echo "⚙️ PVE ARM64 RPI CONTROL - SYSTEM PREPARE"
echo "========================================"

echo
echo "🔍 ROOT CHECK"
if [ "$EUID" -ne 0 ]; then
  echo "❌ Script muss als root laufen!"
  exit 1
fi

echo "✅ Root OK"

echo
echo "🔍 DEBIAN CHECK"
if ! grep -qi debian /etc/os-release; then
  echo "❌ Kein Debian System erkannt!"
  cat /etc/os-release
  exit 1
fi

echo "✅ Debian erkannt"

echo
echo "🔍 ARCH CHECK"
ARCH=$(dpkg --print-architecture)
if [ "$ARCH" != "arm64" ]; then
  echo "❌ Nicht arm64! ($ARCH)"
  exit 1
fi

echo "✅ Architektur OK: $ARCH"

echo
echo "⚡ BOOT FIX: systemd-networkd-wait-online deaktivieren"
systemctl disable systemd-networkd-wait-online.service 2>/dev/null || true
systemctl mask systemd-networkd-wait-online.service 2>/dev/null || true
echo "✅ wait-online deaktiviert/maskiert"

echo
echo "📡 RASPBERRY PI FIX: WLAN/Bluetooth deaktivieren"
CONFIG_TXT="/boot/firmware/config.txt"

if [ -f "$CONFIG_TXT" ]; then
  grep -qxF "dtoverlay=disable-wifi" "$CONFIG_TXT" || echo "dtoverlay=disable-wifi" >> "$CONFIG_TXT"
  grep -qxF "dtoverlay=disable-bt" "$CONFIG_TXT" || echo "dtoverlay=disable-bt" >> "$CONFIG_TXT"
  echo "✅ WLAN/Bluetooth deaktiviert in $CONFIG_TXT"
else
  echo "⚠️ $CONFIG_TXT nicht gefunden - übersprungen"
fi

echo
echo "🔄 APT UPDATE"
apt update

echo
echo "⬆️ BASIS PAKETE INSTALLIEREN"
apt install -y \
  curl \
  wget \
  gnupg \
  lsb-release \
  ca-certificates \
  apt-transport-https

echo
echo "🔧 NETWORK TOOLS"
apt install -y \
  ifupdown2 \
  net-tools

echo
echo "🔍 HOSTNAME"
hostnamectl

echo
echo "========================================"
echo "✅ SYSTEM PREPARE FERTIG"
echo "========================================"
