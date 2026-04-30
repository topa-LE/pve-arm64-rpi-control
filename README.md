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
Basierend auf Debian 13 Lite (Trixie)

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

## 🔹 Vorbereitung (einmalig notwendig)
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




