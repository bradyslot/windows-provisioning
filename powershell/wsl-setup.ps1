<#
wsl-install.ps1

This script is intended to be run on a fresh Windows
installation from windows startup after enabling WSL2
and placed in the c
#>

# Utility function to format text
function Text-Format {
	param (
		[string]$Message,
		[string]$Type = "INFO",
	)
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