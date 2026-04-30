#!/bin/bash
set -e

echo "========================================"
echo "📦 ADD PROXMOX REPOSITORY"
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
apt install -y curl gnupg ca-certificates

echo
echo "🔑 Key setzen"
mkdir -p /etc/apt/keyrings

curl -fsSL https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg \
  -o /etc/apt/keyrings/proxmox.gpg

chmod 644 /etc/apt/keyrings/proxmox.gpg

echo
echo "📦 Repo setzen"
cat > /etc/apt/sources.list.d/proxmox.list <<'REPO'
deb [signed-by=/etc/apt/keyrings/proxmox.gpg] http://download.proxmox.com/debian/pve bookworm pve-no-subscription
REPO

echo
echo "🔄 APT UPDATE"
apt update

echo
echo "========================================"
echo "✅ PROXMOX REPO FERTIG"
echo "========================================"
