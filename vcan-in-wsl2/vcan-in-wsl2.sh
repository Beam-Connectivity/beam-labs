# #!/bin/bash

# Get the directory of the script
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Update and install required packages
echo !!!!!!!!!!!!!!!!!!!!!!!!!
echo Install required packages
echo !!!!!!!!!!!!!!!!!!!!!!!!!
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y libelf-dev flex bison libssl-dev libncurses-dev bc build-essential make
sudo apt install -y --no-install-recommends wslu
sleep 5

# The v1.21 of dwarves (and its dependency pahole) is required.
echo !!!!!!!!!!!!!!!!!!!!!
echo Install dwarves v1.21
echo !!!!!!!!!!!!!!!!!!!!!
if [[ ! -f "dwarves_1.21-0ubuntu1~20.04.1_amd64.deb" ]]; then
echo !!!!!!!!!!!!!!Downloading dwarves 1.21!!!!!!!!!!!!!!!!!!!!!
wget http://archive.ubuntu.com/ubuntu/pool/universe/d/dwarves-dfsg/dwarves_1.21-0ubuntu1~20.04.1_amd64.deb
fi
sudo apt install ./dwarves_1.21-0ubuntu1~20.04.1_amd64.deb
sleep 5

# Clone and checkout the WSL2 Linux Kernel
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo Clone and checkout the WSL2 Linux Kernel
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if [[ ! -d "/WSL2-Linux-Kernel/" ]]; then
    git clone git@github.com:microsoft/WSL2-Linux-Kernel.git --shallow-since=2022-07-30
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
make -j$(( $(nproc) - 1 ))
sudo make modules_install
sudo ln -s /lib/modules/5.15.57.1-microsoft-standard-WSL2+/ /lib/modules/5.15.57.1-microsoft-standard-WSL2
sleep 5

# Find and store Windows username
WIN_USER=$(wslpath "$(wslvar USERPROFILE)")

# Copy kernel to Windows home directory
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo Copy kernel and wsl-reboot.sh to Windows
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
cp vmlinux $WIN_USER/
cd $WIN_USER
touch .wslconfig
cat >> .wslconfig << "ENDL"
[wsl2]
kernel=C:\\Users\\$WIN_USER\\vmlinux
ENDL
cd $SCRIPT_PATH
echo $SCRIPT_PATH
cp wsl-reboot.ps1 $WIN_USER
echo Done! Now open a Windows powershell and launch the wsl-reboot.ps1 script to reboot WSL.