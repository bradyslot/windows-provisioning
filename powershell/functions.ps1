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

# Utility function to run commands in WSL
function Invoke-WSL(
	[string]$Command
) {
    wsl -d Ubuntu -- "$Command"
}