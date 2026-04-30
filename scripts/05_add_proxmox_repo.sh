#!/bin/bash
set -e

echo "========================================"
echo "📦 ADD PXVIRT ARM64 REPOSITORY (FINAL)"
echo "========================================"

echo
echo "🔍 ROOT CHECK"
if [ "$EUID" -ne 0 ]; then
  echo "❌ Script muss als root laufen!"
  exit 1
fi
echo "✅ Root OK"

echo
echo "📦 Pakete sicherstellen"
apt update
apt install -y curl ca-certificates gnupg

echo
echo "🧹 Alte/falsche Proxmox Repo-Dateien entfernen"
rm -f /etc/apt/sources.list.d/proxmox.list
rm -f /etc/apt/sources.list.d/pve-install-repo.list
rm -f /etc/apt/keyrings/proxmox.gpg

echo
echo "🔑 PXVIRT Key setzen"
mkdir -p /etc/apt/keyrings

curl -fsSL https://mirrors.lierfang.com/pxcloud/lierfang.gpg \
  -o /etc/apt/keyrings/pxvirt.gpg

chmod 644 /etc/apt/keyrings/pxvirt.gpg

echo
echo "📦 PXVIRT Repo setzen"
cat > /etc/apt/sources.list.d/pxvirt.list <<'REPO'
deb [signed-by=/etc/apt/keyrings/pxvirt.gpg] https://mirrors.lierfang.com/pxcloud/pxvirt trixie main
REPO

echo
echo "🔄 APT UPDATE"
apt update

echo
echo "========================================"
echo "✅ PXVIRT ARM64 REPO FERTIG"
echo "========================================"
