<#
run.ps1

This script is intended to be run on a fresh Windows
installation to set up a daily drive environment.

Tested on Windows 11 24H2 but should run on Windows 10
as it also uses PowerShell 5.1 by default.
#>
$execution_policy = Get-ExecutionPolicy
if ($execution_policy -eq "Restricted") {
	Set-ExecutionPolicy Bypass -Scope Process -Force;
}

# Download and install Chocolatey
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Refresh environment vars
# commented out as this may not work yet
# refreshenv

# Install Python using Chocolatey
choco install python -y

# Install Git and pull provisioning repo
choco install git.install -y
# git clone {git url goes here}
# cd .\{cloned dir goes here}

# Update pip and install Ansible
python -m pip install --upgrade pip
# python -m venv .venv
# .\.venv\Scripts\activate.ps1
# python -m pip install -r .\requirements.txt --no-warn-script-location



