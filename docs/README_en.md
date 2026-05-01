# 🖥️ PIMOX ARM64 RPI CONTROL

Proxmox VE (Pimox) Build System for Raspberry Pi 4 and Raspberry Pi 5  
Based on Debian 13 (Trixie) ARM64

---

## 🚀 Overview

This project provides a complete and reproducible build system to transform a Raspberry Pi into a fully working Proxmox VE (Pimox) node.

The goal is a clean, stable and fully automated setup without manual adjustments.

---

## ✨ Features

- 🔧 Automated build workflow
- 📦 Proxmox VE installation on ARM64
- 🌐 Clean vmbr0 network setup
- ⚡ Live migration without SSH disconnect
- 🔄 Reproducible deployment
- 🧩 PXVIRT ARM64 repository integration

---

## ⚠️ Important Notice

This project is intended for **homelab / testing environments**

❗ Not an officially supported Proxmox VE ARM platform

---

## 🔐 Default Login
```text
User: root  
Password: pimox  
```

⚠️ Security:

- Change password after first login
- Do not use default credentials in production

---

## 🇬🇧 Recommended Installation Flow (Raspberry Pi 4)

For a stable and reproducible setup, Debian ARM64 booting from USB/NVMe is strongly recommended.

Important notes:

- ❌ SD cards are not recommended for Proxmox VE
- ✅ USB/NVMe storage provides significantly better stability and performance
- ⚠️ SSH must be available before running build.sh

# Option A – Recommended (prepare image)
- Flash Debian ARM64 image to USB/NVMe
- Enable SSH and root access in the image (e.g. via build server or Linux PC)
- Boot the Raspberry Pi
- connect via SSH

clone the repository and run the installer:

```bash
git clone https://github.com/topa-LE/pve-arm64-rpi-control.git

cd pve-arm64-rpi-control
chmod +x build.sh
./build.sh
```



# Option B – Alternative (local setup)
- Boot Raspberry Pi with monitor and keyboard
- login as root
- enable and configure SSH
- continue via SSH as described above

---
## 🧭 Workflow

1. Install Debian 13 (Trixie)
2. Boot system (eth0 via DHCP)
3. Clone repository
4. Run build.sh
5. Proxmox VE will be installed
6. Network will migrate to vmbr0
7. Reboot
8. Access via web interface

---

## 🌉 Network Concept

The system uses the standard Proxmox networking model:

- eth0 → bridge port only
- vmbr0 → main IP interface

Important:

- Migration happens after installation
- Live switch prevents SSH disconnect
- No dual IP setup

---

## ❌ Not Included

- ❌ WiFi configuration
- ❌ Static IP preset
- ❌ GUI customization
- ❌ Auto cluster join

---

## ✅ Tested On

- Raspberry Pi 4
- Raspberry Pi 5
- Debian 13 (Trixie)
- Kernel 6.12+
- Proxmox VE 9

---

## 🧠 Notes

- vmbr0 is configured after installation
- Backup is created before network changes
- Live migration is tested and stable
- Fully reproducible setup

---

## 📦 Status

✔ Stable  
✔ Tested  
✔ Ready  

---

## 👨‍💻 Author

topa-LE
