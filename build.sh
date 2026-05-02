#!/bin/bash
set -e

echo "========================================"
echo "🚀 PVE ARM64 RPI CONTROL BUILD"
echo "========================================"

echo
echo "🔎 STEP 00 - SYSTEM CHECK"
bash scripts/00_system_check.sh

echo
echo "🧾 STEP 01 - HARDWARE REPORT"
bash scripts/01_hardware_report.sh

echo
echo "🧰 STEP 02 - PREPARE SYSTEM"
bash scripts/02_prepare_system.sh

echo
echo "📏 STEP 03 - EXPAND ROOT FILESYSTEM"
bash scripts/03_expand_rootfs.sh

echo
echo "🌉 STEP 04 - CONFIGURE NETWORK BRIDGE"
bash scripts/04_configure_network_bridge.sh

echo
echo "🌉 STEP 05 - ENABLE VMBR0"
bash scripts/05_enable_vmbr0.sh

echo
echo "📦 STEP 06 - PXVIRT ARM64 REPO"
bash scripts/06_add_proxmox_repo.sh

echo
echo "📦 STEP 07 - INSTALL PROXMOX VE"
bash scripts/07_install_proxmox_ve.sh

echo
echo "🌉 STEP 08 - VMBR0 LIVE SWITCH"
echo ""
echo "⚠️ WICHTIG:"
echo "Nach STEP 05 bitte reboot ausführen!"
echo "Ohne Reboot wird vmbr0 nicht aktiv."
echo ""

bash scripts/08_enable_vmbr0_live_switch.sh

echo
echo "========================================"
echo "✅ FINAL BUILD FERTIG"
echo "========================================"

echo
echo "⚠️ Jetzt Reboot-Test:"
echo "reboot"
