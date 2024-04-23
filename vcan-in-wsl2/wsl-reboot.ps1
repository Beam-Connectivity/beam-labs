# Function to shut down WSL
function Stop-WSL {
    # Stop WSL
    wsl --shutdown
}

# Function to check the list of running WSL instances
function Check-WSLList {
    # Get list of running WSL instances
    $wslList = wsl --list --running

    # Output the list
    Write-Output $wslList
}

# Shut down WSL
Stop-WSL

# Wait for 10 seconds
Start-Sleep -Seconds 10

# Check the list of running WSL instances
Check-WSLList
