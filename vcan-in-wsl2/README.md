## WSL CLI

In Windows, open a WSL terminal and launch `vcan-in-wsl2.sh` script.

A Linux Kernel Configuration menu will open. In the `General Setup` section, we can select vcan and slcan (press M for module support)

Go to Networking support
M CAN bus subsystem support
M ISO 15765-2:2016 CAN transport protocol

Go to CAN Device Drivers
M Virtual Local CAN Interface (vcan)
M Serial / USB serial CAN Adaptors (slcan)
M Kvaser PCIe FD Cards
M PEAK-System PCAN-PCIe FD cards