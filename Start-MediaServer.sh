#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -f "$SCRIPT_DIR/config.env" ]]; then
    echo "Error: config.env not found."
    echo "Copy config.example.env to config.env and add your VM details first."
    exit 1
fi

source "$SCRIPT_DIR/config.env"

echo "Starting $VM_NAME..."
virsh start "$VM_NAME" 2>/dev/null

echo "Waiting for VM network, SSH, and Jellyfin (port 8096) to wake up..."
until ssh -o BatchMode=yes -o ConnectTimeout=2 -o StrictHostKeyChecking=no "$VM_USER@$VM_IP" "ss -tln | grep -q :8096" 2>/dev/null; do
    sleep 2
done

echo "=========================================="
echo "Media Server is Live!"
echo "Connect on your LAN device using your Host IP + :8096"
echo "Press Ctrl+C in this window to stop & shut down the VM."
echo "=========================================="

ssh -N -L 0.0.0.0:8096:localhost:8096 "$VM_USER@$VM_IP"

echo ""
echo "Tunnel closed. Safely shutting down $VM_NAME..."
virsh shutdown "$VM_NAME"
sleep 3
