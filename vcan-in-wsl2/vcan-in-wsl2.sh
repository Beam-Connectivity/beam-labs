#!/bin/bash
SCRIPT_PATH="$(dirname "$0")"

# Update and install required packages
echo !!!!!!!!!!!!!!!!!!!!!!!!!
echo Install required packages
echo !!!!!!!!!!!!!!!!!!!!!!!!!
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y libelf-dev flex bison libssl-dev libncurses-dev bc build-essential make
sleep 5

# The v1.21 of dwarves (and its dependency pahole) is required.
echo !!!!!!!!!!!!!!!!!!!!!
echo Install dwarves v1.21
echo !!!!!!!!!!!!!!!!!!!!!
wget http://archive.ubuntu.com/ubuntu/pool/universe/d/dwarves-dfsg/dwarves_1.21-0ubuntu1~20.04.1_amd64.deb
sudo apt install ./dwarves_1.21-0ubuntu1~20.04.1_amd64.deb
sleep 5

# Clone and checkout the WSL2 Linux Kernel
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo Clone and checkout the WSL2 Linux Kernel
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if [[ ! -d "/WSL2-Linux-Kernel/" ]]; then
    git clone https://github.com/microsoft/WSL2-Linux-Kernel --shallow-since=2022-07-30
fi
cd WSL2-Linux-Kernel/
git checkout linux-msft-wsl-5.15.57.1 # This version has canfd drivers as well as regular can drivers
cat /proc/config.gz | gunzip > .config
make prepare modules_prepare
sleep 5

# Configure kernel
echo !!!!!!!!!!!!!!!!
echo Configure kernel
echo !!!!!!!!!!!!!!!!
make menuconfig 
sleep 5

# Build the kernel
echo !!!!!!!!!!!!
echo Build kernel
echo !!!!!!!!!!!!
make -j$(nproc)
sudo make modules_install
sudo ln -s /lib/modules/5.15.57.1-microsoft-standard-WSL2+/ /lib/modules/5.15.57.1-microsoft-standard-WSL2
sleep 5

# Find and store Windows username
WIN_USER=$(powershell.exe '$env:UserName')

# Copy kernel to Windows home directory
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo Copy kernel and wsl-reboot.sh to Windows
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
cp vmlinux /mnt/c/Users/$WIN_USER/
cat >> /mnt/c/Users/$WIN_USER/.wslconfig << "ENDL"
[wsl2]
kernel=C:\\Users\\$WIN_USER\\vmlinux
ENDL
cd $SCRIPT_PATH
cp wsl-reboot.ps1 /mnt/c/Users/$WIN_USER/

echo Done! Now open a Windows powershell and launch the wsl-reboot.ps1 script to reboot WSL.