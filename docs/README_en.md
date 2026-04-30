# 🖥️ PIMOX ARM64 RPI CONTROL

Proxmox VE (Pimox) Build System for Raspberry Pi 4 and Raspberry Pi 5  
Based on Debian 13 (Trixie)

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
