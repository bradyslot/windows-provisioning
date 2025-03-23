#Requires -RunAsAdministrator
<#
wsl-install.ps1

This script is intended to be run on a fresh Windows
installation from windows startup after enabling WSL2
and placed in the c
#>

# Load functions
. ".\functions.ps1"

# Confirm execution policy isn't restricted
$ExecutionPolicy = Get-ExecutionPolicy
if ($ExecutionPolicy -eq "Restricted") {
	Text-Format "Execution policy restricted" "WARNING"
	Text-Format "Setting to Bypass for this session" "WARNING"
	Set-ExecutionPolicy Bypass -Scope Process -Force;
}


Text-Format "Installing WSL2" "WSL"

# Set WSL 2 as the default version
wsl --set-default-version 2

# Install WSL2
wsl --install -d Ubuntu
wsl --update
Text-Format "WSL2 Installed" "WSL"
Text-Format "Installing Python3 and Git in WSL2" "WSL"

# Set default user as root until we setup a default "ansible" user
wsl -d Ubuntu --user root

# Update and install Python3 and Ansible
Invoke-WSL `
	"apt update && `
    apt upgrade -y && `
    apt install -y python3 python3-pip python3-venv git"
Text-Format "Python3 and Git Installed" "WSL"
Text-Format "Setting up user 'ansible' in WSL2" "WSL"
Invoke-WSL "useradd -m -s /bin/bash ansible"
# Set default user as ansible

wsl --terminate Ubuntu
wsl -d Ubuntu --user ansible
Text-Format "User 'ansible' setup" "WSL"

# Run next script to setup Ansible
# TODO: Remove this script from startup after running
# and add next script to run on next login (in case of
# unscheduled restart)
& ".\ansible.ps1"