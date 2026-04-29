#!/bin/bash
set -e

echo "========================================"
echo "🚀 PIMOX ARM64 RPI CONTROL - MASTER BUILD"
echo "========================================"

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
echo "🌉 STEP 4 - NETWORK BRIDGE"
bash scripts/03_configure_network_bridge.sh

echo
echo "========================================"
echo "✅ BUILD FERTIG"
echo "========================================"
echo
echo "⚠️ WICHTIG:"
echo "➡️ System jetzt REBOOTEN:"
echo "reboot"
