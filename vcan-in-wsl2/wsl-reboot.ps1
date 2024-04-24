# Function to shut down WSL
function Stop-WSL {
    # Stop WSL
    wsl --shutdown
}

# Function to check the list of running WSL instances
function Check-WSLList {
    # Get list of running WSL instances
    $wslList = wsl --list -v

    # Output the list
    Write-Output $wslList
}

# Get the Windows username
$WIN_USER = $env:USERNAME

# Construct the kernel path
$kernel_path = "C:\\Users\\$WIN_USER\\vmlinux"

# Add the lines to the file
Add-Content -Path "C:\\Users\\$WIN_USER\\.wslconfig" -Value "[wsl2]"
Add-Content -Path "C:\\Users\\$WIN_USER\\.wslconfig" -Value "kernel=$kernel_path"


# Shut down WSL
Stop-WSL

# Wait for 10 seconds
Start-Sleep -Seconds 10

# Check the list of running WSL instances
Check-WSLList
