# mediaserver-vm

This server acts as an on-demand homelab media server running **Ubuntu Server** inside **QEMU/KVM (`virt-manager`)** on a **Linux Mint** Wi-Fi host.

## Network Flow
```text
[LAN Device] ---> [Host Wi-Fi IP :8096] ---> [SSH Tunnel] ---> [Ubuntu VM :8096 (Jellyfin)]
```
## Disk Layout
```text
[/dev/vda (40G Logical Volume Manager) --> / (OS & Jellyfin)]
[/dev/vdb (80G) --> /srv/media (Media Library)]
```

## Quick Setup
1. **VM Setup:** Install Ubuntu Server in `virt-manager` using default NAT networking.
2. **Services:** Install **Samba** (sharing `/srv/media` with `775` group permissions) and **Jellyfin** (`8096`).
3. **Passwordless SSH:** Generate an SSH key on the host (`ssh-keygen -t ed25519`) and copy it to the VM (`ssh-copy-id user@vm-ip`).
4. **Configure Launcher:**
   ```bash
   cp config.example.env config.env
   nano config.env
   chmod +x Start-MediaServer.sh
   ```
5. **Run:** Run `Start-MediaServer.sh`-> Press `Ctrl+C` when finished to close the tunnel and shut down the VM.

---
*Built as a first homelab project to practice Linux virtualization, permissions, Samba file sharing, and SSH tunneling, with AI assistance used for some scripting and troubleshooting.*
