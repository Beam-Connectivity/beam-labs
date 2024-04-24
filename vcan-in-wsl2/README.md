Note: wsl once you replace the wsl linux kernel with the custom kernel, every distribution in wsl will use 

## Generate SSH key
Make sure the public SSH key is associated with the GitHub account. [Here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) are some instructions on how to create an ssh key on your machine.

## WSL CLI
In Windows, open a WSL terminal and launch `vcan-in-wsl2.sh` script:
```
./vcan-in-wsl2.sh
```

You will be asked to continue with the installation of `dwarves v1.21`. Alternative, it could be possible to use a newer version of dwarves by [skipping the btf encoding from the `pahole` invoke in the kernel build](https://unix.stackexchange.com/questions/754325/failed-load-btf-from-vmlinux-invalid-argument-make-on-config-debug-info-btf-y/772051#772051), however this hasn't been tested. Type `y` and `ENTER`.

Accept the default for all the kernel configuration requests.

Subsequently, a linux kernel configuration menu will open. In the `General Setup` section, we need to  enable support for vcan and slcan.

## Powershell

Once the `vcan-in-wsl2.sh` script is done, close the wsl terminal and run a powershell.

First, you'll need to temporary bypass the execution policy to run the script. This is achieved by running the following command:
```
Set-ExecutionPolicy Bypass -Scope Process
```
From the user home directory, run the `wsl-reboot.ps1` script:
```
./wsl-reboot.ps1
```

At completion, open a new wsl terminal and type `uname -a`. If the proces was successful, you should see the `5.15.57.1-microsoft-standard-WSL2+` in the output.

Finally, launch the following command to add module from the linux kernel:
```
sudo modprobe can; sudo modprobe can-raw; sudo modprobe vcan; sudo modprobe slcan; sudo modprobe can-isotp; sudo modprobe peak_usb; sudo modprobe kvaser_usb
```