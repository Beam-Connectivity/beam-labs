
## Generate SSH key
Make sure the public SSH key is associated with the GitHub account. 

## WSL CLI
In Windows, open a WSL terminal and launch `vcan-in-wsl2.sh` script.

You will be asked to continue with the installation of `dwarves v1.21`. Type `y` and `ENTER`.

Accept the default for all the kernel configuration requests.

Subsequently, a linux kernel configuration menu will open. In the `General Setup` section, we need to  enable support for vcan and slcan. Use `ENTER` to access sub-configurations and `M` for module support

`ENTER` Networking support

->`M` CAN bus subsystem support

-> `M` ISO 15765-2:2016 CAN transport protocol

`ENTER` Go to CAN Device Drivers

-> `M` Virtual Local CAN Interface (vcan)

-> `M` Serial / USB serial CAN Adaptors (slcan)

-> `M` Kvaser PCIe FD Cards

-> `M` PEAK-System PCAN-PCIe FD cards

## Powershell

Once the `vcan-in-wsl2.sh` script is done, close the wsl terminal and run a powershell as administrator.

From the user home directory, run the `wsl-reboot.ps1` script.

At completion, open a new wsl terminal and type `uname -a`. If the proces was successful, you should see the `5.15.57.1-microsoft-standard-WSL2+` in the output