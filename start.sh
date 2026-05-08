#!/bin/bash
# Start the PXE server in the foreground.
# Listens only on enp42s0 (LAN). proxyDHCP mode — does not assign IPs.
# Stop with Ctrl-C.
#
# Run with sudo:  sudo ~/pxe-server/start.sh
# (TFTP and DHCP need root for raw socket / port 67 binding.)

set -euo pipefail
cd "$(dirname "$0")"

if [[ $EUID -ne 0 ]]; then
    echo "Error: must be run as root. Try:  sudo $0" >&2
    exit 1
fi

echo "Starting dnsmasq in proxyDHCP+TFTP mode on enp42s0..."
echo "Stop with Ctrl-C."
echo ""

# Run dnsmasq as a backgrounded child of this script.
# bash stays the foreground process and receives Ctrl-C directly,
# then forwards SIGTERM to dnsmasq for a clean shutdown.
dnsmasq --conf-file=./dnsmasq.conf --no-resolv --no-hosts &
DNSMASQ_PID=$!

cleanup() {
    echo ""
    echo "Stopping dnsmasq (pid $DNSMASQ_PID)..."
    kill -TERM "$DNSMASQ_PID" 2>/dev/null || true
    wait "$DNSMASQ_PID" 2>/dev/null || true
    exit 0
}
trap cleanup INT TERM

wait "$DNSMASQ_PID"
