# update
sudo apt-get update

# required packages
sudo apt install -y libelf-dev dwarves flex bison libssl-dev \
    libncurses-dev bc make build-essential
 
# The below few connamds will checkout the 1GB default kernel
git clone https://github.com/microsoft/WSL2-Linux-Kernel
cd WSL2-Linux-Kernel/
git checkout linux-msft-wsl-`uname -r | cut -d'-' -f1 |  tr -d '\n'`
cat /proc/config.gz | gunzip > .config
make prepare modules_prepare
 
# The next command brings up the kernel configuration.
# In here we can select vcan and slcan. You can also enable other modules you
# require and test if they work. The link below helps locate modules in the
# menu config display. For wsl v5.10.102 it was located at:
# Networking support -> CAN bus subsystem support -> CaN Device Drivers -> vcan
# https://www.kernelconfig.io/config_can_vcan
make menuconfig 

#build the kernel
make -j4

#make modules and install them
make modules
sudo make modules_install

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

