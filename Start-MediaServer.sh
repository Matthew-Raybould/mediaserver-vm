#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

if [[ ! -f "$SCRIPT_DIR/config.env" ]]; then
    echo "ERROR: config.env not found in $SCRIPT_DIR"
    read -p "Press Enter to close..."
    exit 1
fi

source "$SCRIPT_DIR/config.env"

echo "Starting SIEM Server: $SIEM_NAME..."
virsh -c qemu:///system start "$SIEM_NAME"
echo "Please wait..."
sleep 15

echo "Starting Media Server: $VM_NAME..."
virsh -c qemu:///system start "$VM_NAME"

echo "Waiting for VM network, SSH, and Jellyfin (port 8096)..."
until ssh -o BatchMode=yes -o ConnectTimeout=2 -o StrictHostKeyChecking=no "$VM_USER@$VM_IP" "ss -tln | grep -q :8096" 2>/dev/null; do
    sleep 2
done

echo "=========================================="
echo "Media Server is Live!"
echo "Connect on your LAN device using your Host IP + :8096"
echo "Press Ctrl+C in this window to stop & shut down the VM."
echo "=========================================="

ssh -N -L 0.0.0.0:8096:127.0.0.1:8096 "$VM_USER@$VM_IP"

echo ""
echo "Tunnel closed. Safely shutting down $VM_NAME and $SIEM_NAME..."
virsh -c qemu:///system shutdown "$VM_NAME"
virsh -c qemu:///system shutdown "$SIEM_NAME"
echo "Please wait..."
sleep 15
read -p "Done! Press Enter to close this window..."
