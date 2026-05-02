# 🚀 PIMOX ARM64 – Proxmox VE auf Raspberry Pi 4/5

🇩🇪 Deutsch | 🇬🇧 [English version](docs/README_en.md)

![PIMOX ARM64](https://img.shields.io/badge/PIMOX-ARM64-blue?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Raspberry%20Pi%204%2F5-orange?style=for-the-badge)
![Debian](https://img.shields.io/badge/Debian-13%20Trixie-red?style=for-the-badge)
![Proxmox](https://img.shields.io/badge/Proxmox-VE%209-green?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Testing-yellow?style=for-the-badge)
![Network](https://img.shields.io/badge/Network-vmbr0%20Bridge-blueviolet?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-lightgrey?style=for-the-badge)


Proxmox VE (Pimox) Build System für Modell Raspberry Pi 4 und Raspberry Pi 5 New  
Basierend auf Debian 13 Lite (Trixie) ARM64

---

## ⚡ One-Click Installer für Proxmox VE (ARM64)

Dieses Projekt ermöglicht die Installation eines Proxmox VE ähnlichen Systems (Pimox/PXVirt) auf einem Raspberry Pi (ARM64) mit einem stabilen, reproduzierbaren Netzwerk-Setup.

---

## ✨ Features

- 🔧 Automatischer Build Workflow
- 📦 Proxmox VE Installation auf ARM64
- 🌐 Sauberes Netzwerk Setup mit vmbr0
- ⚡ Live Migration ohne SSH Verlust
- 🔄 Reproduzierbares Setup
- 🧩 PXVIRT ARM64 Repository Integration

---

# 🎯 Ziel
- 🔧 Automatisierter Build-Prozess
- 🌉 Sauberes Bridge-Netzwerk (vmbr0)
- ⚡ Kein Live-Network-Switch (keine SSH-Abbrüche)
- 🔁 Reproduzierbarer Installer
- 🧠 Minimale Fehleranfälligkeit



## ⚠️ WICHTIG – Netzwerkstrategie

Dieses Projekt verwendet KEIN Live Network Switching.

- 👉 Warum?

1. Vermeidet SSH-Abbrüche
2. Vermeidet Lock-Probleme (ifupdown2)
3. Vermeidet Konflikte mit netplan/systemd-networkd

- 👉 Stattdessen:

- Netzwerk wird persistent geschrieben
- Aktivierung erfolgt ausschließlich per Reboot

- ➡️ Das entspricht dem Verhalten eines echten Proxmox Installers


Dieses Projekt ist für **Homelab / Test / Lab Umgebungen** gedacht.

❗ Kein offiziell unterstütztes Proxmox VE System auf ARM

---

## 🇩🇪 Empfohlener Installationsablauf (Raspberry Pi 4)

Für eine stabile und reproduzierbare Installation wird Debian ARM64 von USB/NVMe empfohlen.

Wichtige Hinweise:

- ❌ SD-Karten sind für Proxmox VE nicht empfohlen
- ✅ USB-/NVMe-Storage bietet deutlich bessere Stabilität und Performance
- ⚠️ SSH muss vor dem Ausführen von build.sh verfügbar sein

---

## 🔧 Image Vorbereitung (empfohlen – Option A)

Für einen vollständig headless Betrieb (ohne Monitor/Tastatur) wird empfohlen,
das Image vor dem ersten Boot vorzubereiten.

Dafür steht folgendes Script zur Verfügung:

```text
scripts/09_prepare_pve_image.sh
```

Dieses Script übernimmt automatisch:

- ✅ SSH Installation + Aktivierung
- ✅ Root Login (Passwort: pimox)
- ✅ DNS Fix (für chroot Umgebung)
- ✅ ARM64 Validierung
- ✅ Hostname + /etc/hosts Setup

#### Nutzung:

1. Image auf USB / SSD / NVMe (per Adapter) flashen  
2. Datenträger an einem Linux-System anschließen  
3. Script ausführen:

```bash
sudo bash scripts/08_prepare_pve_image.sh  
```

4. Zielpartition auswählen (z. B. /dev/sdb1)  
5. Datenträger in Raspberry Pi einsetzen und booten  

Danach ist ein direkter SSH-Zugriff möglich:
```text
ssh root@<IP>  
```

Passwort:
```text
pimox 
```
---

# Option A – Empfohlen (Image vorbereiten)
- Debian ARM64 Image auf USB/NVMe flashen
- SSH und Root-Zugriff im Image aktivieren (z. B. über Build-Server oder Linux-PC)
- Raspberry Pi booten
- per SSH verbinden

Repository klonen und Installer starten:

```bash
git clone https://github.com/topa-LE/pve-arm64-rpi-control.git

cd pve-arm64-rpi-control
chmod +x build.sh
./build.sh
```


# Option B – Alternative (lokal am Gerät)
- Raspberry Pi mit Monitor und Tastatur starten
- als root einloggen
- SSH aktivieren und konfigurieren
- danach wie oben per SSH fortfahren

---

## 🔹 Vorbereitung bei Option B (einmalig notwendig)
- Debian 13 (ARM64) Image auf SD-Karte flashen
- SD-Karte in Raspberry Pi stecken und booten
- Monitor + Tastatur anschließen


## 🔹 Erster Login

Standard Login (je nach Image):

```text
Benutzer: root
Passwort: pimox
```


## 🔹 SSH aktivieren


```bash
apt update
apt install -y openssh-server
systemctl enable ssh
systemctl start ssh
```

---

## 🔐 Default Login

```text
User: root  
Password: pimox  
```


⚠️ Sicherheit:

- Passwort nach erstem Login ändern
- Nicht produktiv mit Default Credentials betreiben

---

## 📦 Voraussetzungen
- Raspberry Pi 4 / 5 (ARM64)
- Debian 13 (Trixie) ARM64 installiert
- SSH Zugriff aktiv
- Root Zugriff (root / pimox)


## 🧭 Workflow

1. Debian 13 (Trixie) installieren
2. System starten (eth0 DHCP)
3. Repository klonen
4. build.sh ausführen
5. Proxmox VE wird installiert
6. Netzwerk wird auf vmbr0 umgestellt
7. Reboot
8. Zugriff über Webinterface

---

## ▶️ Installation

```bash
git clone https://github.com/topa-LE/pve-arm64-rpi-control.git
cd pve-arm64-rpi-control
chmod +x build.sh
sudo ./build.sh
```

---


## 🌉 Netzwerk Konzept

Das System nutzt das klassische Proxmox Netzwerkmodell:

- eth0 → nur Bridge Port
- vmbr0 → Haupt-IP Interface


---

## 🌉 Netzwerk (WICHTIG)

Das System verwendet:
```text
eth0 → nur Bridge Port
vmbr0 → Haupt-IP Interface
```

Beispiel:
```text
vmbr0 → 192.168.x.x
Gateway → Router
```

---


## ❌ Nicht enthalten

- ❌ WLAN Setup
- ❌ Feste IP Vorgabe
- ❌ GUI Anpassungen
- ❌ Auto Cluster Join

---

## 📁 Projektstruktur

| Pfad / Datei                             | Beschreibung                                               |
| ---------------------------------------- | ---------------------------------------------------------- |
| `build.sh`                               | 🚀 Hauptinstaller – führt alle Schritte in Reihenfolge aus |
| `scripts/00_system_check.sh`             | 🔍 Systemprüfung (Architektur, OS, Basischecks)            |
| `scripts/01_hardware_report.sh`          | 🖥️ Hardware-Infos (CPU, RAM, Devices)                     |
| `scripts/02_prepare_system.sh`           | 📦 Basis-Pakete + System vorbereiten                       |
| `scripts/03_expand_rootfs.sh`            | 💾 RootFS auf volle Größe erweitern                        |
| `scripts/04_configure_network_bridge.sh` | 🌐 Netzwerk vorbereiten (ohne Aktivierung)                 |
| `scripts/05_enable_vmbr0.sh`             | 🌉 Schreibt finale vmbr0 Bridge-Konfiguration              |
| `scripts/06_add_proxmox_repo.sh`         | 📥 PXVIRT / Proxmox Repo hinzufügen                        |
| `scripts/07_install_proxmox_ve.sh`       | ⚙️ Installation von Proxmox VE Komponenten                 |
| `scripts/08_enable_vmbr0_live_switch.sh` | ℹ️ Deaktiviert – kein Live Switch (nur Info)               |
| `docs/`                                  | 📚 Dokumentation (README, Zusatzinfos)                     |


---

## ✅ Getestet auf

- Raspberry Pi 4
- Raspberry Pi 5
- Debian 13 (Trixie)
- Kernel 6.12+
- Proxmox VE 9

---

## 🧠 Hinweise

- vmbr0 wird bewusst erst nach Installation gesetzt
- Backup vor Netzwerkänderung wird erstellt
- Setup ist vollständig reproduzierbar

---

## 📦 Status

✔ Stabil  
✔ Getestet  
✔ Einsatzbereit  

---

## 👨‍💻 Autor

topa-LE


## MIT Lizenz




