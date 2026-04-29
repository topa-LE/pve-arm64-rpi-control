# pve-arm64-rpi-control

Reproduzierbares Installations- und Kontrollprojekt für PVE / Proxmox-ähnliche ARM64-Komponenten auf Raspberry Pi 4 und Raspberry Pi 5.

## ⚠️ Wichtiger Hinweis

Dieses Projekt ist **kein offizielles Proxmox VE Projekt**.

Proxmox VE unterstützt Raspberry Pi / ARM64 offiziell nicht. Dieses Repository dient der Entwicklung, Dokumentation und Automatisierung eines Community-/Homelab-Ansatzes.

## Ziel

- Raspberry Pi 4 und Raspberry Pi 5 getrennt testen
- Installation reproduzierbar machen
- Änderungen dokumentieren
- Scripts Schritt für Schritt ausführen
- Keine bestehenden Pimox-Systeme beschädigen

## Status

Frühe Entwicklungsphase.

Aktuell vorhanden:

- System-Check Script
- Hardware-Report Script
- Basis-Dokumentation

## Erster Test auf einem Raspberry Pi

```bash
git clone https://github.com/topa-LE/pve-arm64-rpi-control.git
cd pve-arm64-rpi-control
sudo bash scripts/00_system_check.sh
sudo bash scripts/01_hardware_report.sh

Zielgeräte
Raspberry Pi 4 ARM64
Raspberry Pi 5 ARM64
Nicht-Ziel

Dieses Projekt ist aktuell kein produktiver Ersatz für offizielles Proxmox VE auf x86.
