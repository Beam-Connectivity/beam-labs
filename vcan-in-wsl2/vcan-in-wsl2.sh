# required packages
sudo apt install -y libelf-dev flex bison libssl-dev libncurses-dev bc

# The v1.21 of dwarves (and its dependency pahole) is required. Download it in your preferred directory and install it
wget http://archive.ubuntu.com/ubuntu/pool/universe/d/dwarves-dfsg/dwarves_1.21-0ubuntu1~20.04.1_amd64.deb
sudo apt install ./dwarves_1.21-0ubuntu1~20.04.1_amd64.deb

# The below few connamds will checkout the 1GB default kernel
git clone https://github.com/microsoft/WSL2-Linux-Kernel --shallow-since=2022-07-30
cd WSL2-Linux-Kernel/
git checkout linux-msft-wsl-5.15.57.1 # This version has canfd drivers as well as regular can drivers
cat /proc/config.gz | gunzip > .config
make prepare modules_prepare
 
# The next command brings up the kernel configuration.
# In here we can select vcan and slcan.(PRESS M for Module support). You can also enable other modules you
# require and test if they work. The link below helps locate modules in the
# menu config display. For wsl v5.10.102 it was located at:
# Networking support -> CAN bus subsystem support -> CaN Device Drivers -> vcan
# https://www.kernelconfig.io/config_can_vcan
make menuconfig 

# build the kernel
make -j$(nproc)
sudo make modules_install
sudo ln -s /lib/modules/5.15.57.1-microsoft-standard-WSL2+/ /lib/modules/5.15.57.1-microsoft-standard-WSL2
# We'll need to store our custom kernel in the Windows environment and 
# launch it when we start wsl2.
# Change the path below to where you want to store it
cp vmlinux /mnt/c/Users/<USER>/
cat >> /mnt/c/Users/<USER>/.wslconfig << "ENDL"
[wsl2]
kernel=C:\\Users\\<USER>\\vmlinux
ENDL

# We'll need to restart WSL to use the new kernel
# In the command prompt enter the next couple of commands
# wsl --shutdown
# Wait 10 seconds or check everything is stopped with
# wsl --list -v

## Check new custom kernel is used
uname -a