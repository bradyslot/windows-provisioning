#Requires -RunAsAdministrator
<#
ansible.ps1

This script is intended to be run on a fresh Windows
installation from the run.ps1 script to set up this 
device as an Ansible managed node but is designed
as a modular script so that later features can be
chosen based on options (likely command-line 
arguments passed to run.ps1).

Tested on Windows 11 24H2 but should run on Windows 10
as it also uses PowerShell 5.1 by default.
#>

# Load functions
. ".\powershell\functions.ps1"

# Confirm execution policy isn't restricted
$ExecutionPolicy = Get-ExecutionPolicy
if ($ExecutionPolicy -eq "Restricted") {
	Text-Format "Execution policy restricted" "WARNING"
	Text-Format "Setting to Bypass for this session" "WARNING"
	Set-ExecutionPolicy Bypass -Scope Process -Force;
}

Text-Format "Pulling repo and setting up Ansible" "WSL"
Invoke-WSL "git clone https://github.com/yelrom0/windows-provisioning.git"

# python -m venv .venv
# .\.venv\Scripts\activate.ps1
# python -m pip install -r .\requirements.txt --no-warn-script-location