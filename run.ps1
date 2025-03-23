#Requires -RunAsAdministrator
<#
run.ps1

This script is intended to be run on a fresh Windows
installation to set up a daily drive environment.

This script performs the following actions:
	1. Install Chocolatey
	2. Install Git
	3. Clone the provisioning repository
	4. Install Python
	5. Install WSL2
	6. Sets script .\wsl-install.ps1 
	to run on next login
	7. Reboot the system


Tested on Windows 11 24H2 but should run on Windows 10
as it also uses PowerShell 5.1 by default.
#>

# Utility function to format text
function Text-Format(
	[string]$Message,
	[string]$Type = "INFO",
) {
	
	switch ($Type) {
		"INFO" {
			Write-Host "[INFO][SETUP] $Message" -ForegroundColor Blue
		}
		"PACKAGE" {
			Write-Host "[INFO][PACKAGES] $Message" -ForegroundColor Blue
		}
		"WSL" {
			Write-Host "[INFO][WSL SETUP] $Message" -ForegroundColor Blue
		}
		"WARNING" {
			Write-Host "[WARNING][SETUP] $Message" -ForegroundColor Yellow
		}
		"ERROR" {
			Write-Host "[ERROR][SETUP] $Message" -ForegroundColor Red
		}
	}
}

# Confirm execution policy isn't restricted
$ExecutionPolicy = Get-ExecutionPolicy
if ($ExecutionPolicy -eq "Restricted") {
	Text-Format "Execution policy restricted" "WARNING"
	Text-Format "Setting to Bypass for this session" "WARNING"
	Set-ExecutionPolicy Bypass -Scope Process -Force;
}

# Download and install Chocolatey
Text-Format "Installing Chocolatey" "PACKAGE"
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
Text-Format "Chocolatey installed" "PACKAGE"
# Refresh environment vars
# commented out as this may not work yet
# refreshenv

# Install Git and pull provisioning repo
Text-Format "Installing Git" "PACKAGE"
choco install git.install -y
Text-Format "Git Installed" "PACKAGE"
Text-Format "Cloning windows-provisioning repository"
git clone https://github.com/yelrom0/windows-provisioning.git
cd .\windows-provisioning

# Install Python using Chocolatey
Text-Format "Installing Python" "PACKAGE"
choco install python -y
Text-Format "Python installed" "PACKAGE"
Text-Format "Updating pip" "PACKAGE"
python -m pip install --upgrade pip
Text-Format "pip updated" "PACKAGE"

# Enable Features for WSL2
Text-Format "Enabling WSL2" "WSL"
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
Text-Format "WSL2 Enabled" "WSL"

Text-Format "Setting further install scripts to run on next login" "WSL"
# Get the current user, script path and set name for the task
$CurrentUser = $env:USERDOMAIN + "\\" + $env:USERNAME
$ScriptPath = $PWD.Path + "\powershell\wsl-setup.ps1"
$TaskName = "WSL2SetupOnLogin"

# Check if service exists
# Check if the task already exists and delete it if it does
$ExistingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($ExistingTask) {
	Text-Format "Task $TaskName already exists, deleting" "WARNING"
	Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}

# Define the action to run the script
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$ScriptPath`""

# Define the trigger: At logon of current user
$Trigger = New-ScheduledTaskTrigger -AtLogOn -User $CurrentUser

# Define the settings for the task
$Settings = New-ScheduledTaskSettingsSet
$Settings.ExecutionTimeLimit = "PT0" # Run indefinitely
$Settings.AllowDemandStart = $true  # Allow the task to be run manually
$Settings.StopIfGoingOnBatteries = $false # Do not stop on battery
$Settings.WakeToRun = $false   # Do not wake the computer

# Create a principal to run the task as an administrator
$Principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Create the task definition
$TaskDefinition = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings -Principal $Principal

# Register the scheduled task
Register-ScheduledTask -TaskName $TaskName -Definition $TaskDefinition
Text-Format "Scheduled task '$TaskName' created to run '$ScriptPath' on $CurrentUser login." "WSL"

# Countdown and reboot
$RebootSeconds = 10

while ($RebootSeconds -gt 0) {
	Text-Format "Rebooting system to apply changes in $RebootSeconds seconds" "WSL"
	Start-Sleep -Seconds 1
	$RebootSeconds--
}

Restart-Computer -Force