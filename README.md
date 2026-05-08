# pxe-server

On-demand PXE boot server for bare-metal Linux installs over a LAN. Uses [dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html) in proxyDHCP + TFTP mode with [netboot.xyz](https://netboot.xyz) iPXE chainloaders. Runs alongside your existing router's DHCP — no conflicts, no USB media needed.

## Usage

1. Edit `dnsmasq.conf` — set `interface=` to your LAN NIC and `dhcp-range=` to your subnet.
2. Run `sudo ./start.sh`. Ctrl-C to stop.
3. PXE-boot the target machine. It picks up an iPXE menu from netboot.xyz and you choose a distro.

If you have nftables with a default-drop input policy, you'll need to allow UDP ports 67, 69, and 4011 on your LAN interface.

## Files

| File | Purpose |
|------|---------|
| `dnsmasq.conf` | dnsmasq proxyDHCP + TFTP configuration |
| `start.sh` | Launches dnsmasq in the foreground |
| `tftp/netboot.xyz.kpxe` | iPXE for modern BIOS hardware |
| `tftp/netboot.xyz-undionly.kpxe` | iPXE for older hardware (UNDI fallback) |
| `tftp/netboot.xyz.efi` | iPXE for UEFI hardware |

## License

[MIT](LICENSE)
