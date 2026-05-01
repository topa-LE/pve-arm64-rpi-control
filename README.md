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

## 🚀 Übersicht

Dieses Projekt stellt ein vollständiges, reproduzierbares Build-System bereit, um einen Raspberry Pi in einen funktionierenden Proxmox VE (Pimox) Node zu verwandeln.

Ziel ist ein stabiles, sauberes und automatisiertes Setup ohne manuelle Nacharbeit.

---

## ✨ Features

- 🔧 Automatischer Build Workflow
- 📦 Proxmox VE Installation auf ARM64
- 🌐 Sauberes Netzwerk Setup mit vmbr0
- ⚡ Live Migration ohne SSH Verlust
- 🔄 Reproduzierbares Setup
- 🧩 PXVIRT ARM64 Repository Integration

---

## ⚠️ Wichtiger Hinweis

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
Passwort: raspberry
```

ODER
```text
Benutzer: debian
Passwort: debian
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

Wichtig:

- Umstellung erfolgt erst nach Installation
- Live Switch verhindert SSH-Verlust
- Kein doppeltes IP Setup

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
- Live Migration ist getestet und stabil
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




