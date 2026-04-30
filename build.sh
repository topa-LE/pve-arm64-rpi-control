#!/bin/bash
set -e

echo "========================================"
echo "🚀 PIMOX ARM64 RPI CONTROL - FINAL BUILD"
echo "========================================"

if [ "$EUID" -ne 0 ]; then
  echo "❌ Bitte als root ausführen!"
  exit 1
fi

echo
echo "🔍 STEP 1 - SYSTEM CHECK"
bash scripts/00_system_check.sh

echo
echo "🔍 STEP 2 - HARDWARE REPORT"
bash scripts/01_hardware_report.sh

echo
echo "⚙️ STEP 3 - SYSTEM PREPARE"
bash scripts/02_prepare_system.sh

echo
echo "🌐 STEP 4 - SAFE LAN DHCP"
bash scripts/03_configure_network_bridge.sh

echo
echo "📦 STEP 5 - PXVIRT ARM64 REPO"
bash scripts/05_add_proxmox_repo.sh

echo
echo "📦 STEP 6 - PVE INSTALL"
bash scripts/06_install_proxmox_ve.sh

echo
echo "🌉 STEP 7 - VMBR0 LIVE SWITCH"
bash scripts/07_enable_vmbr0_live_switch.sh

echo
echo "========================================"
echo "✅ FINAL BUILD FERTIG"
echo "========================================"
echo
echo "⚠️ Jetzt Reboot-Test:"
echo "reboot"
