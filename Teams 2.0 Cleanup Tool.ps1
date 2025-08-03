<#
    Title: Teams 2.0 Cleanup Tool
    Author: That Bearded IT Guy
    Website: https://thatbeardeditguy.com
    GitHub: https://github.com/<your-username>

    Description:
    Automates the cleanup of Microsoft Teams 2.0 caches and credentials
    to resolve stubborn sign-in loop issues.

    Steps Performed:
    1. Stop Teams processes
    2. Clear Teams cache (Local AppData)
    3. Clear Windows IdentityCache and TokenBroker
    4. Remove Teams/Microsoft-related credentials
    5. Optionally reinstall Teams with the latest installer

    Disclaimer:
    Use at your own risk. Test before deploying widely.
    Script is provided as-is with no warranties or guarantees.
#>

# Confirm Admin Rights
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    Pause
    Exit
}

# Paths
$TeamsCachePath = "$env:LOCALAPPDATA\Microsoft\Teams"
$IdentityCachePath = "$env:LOCALAPPDATA\Microsoft\IdentityCache"
$TokenBrokerPath = "$env:LOCALAPPDATA\Microsoft\TokenBroker"

# Stop Teams Processes
Write-Host "Stopping Microsoft Teams processes..." -ForegroundColor Cyan
Get-Process -Name Teams -ErrorAction SilentlyContinue | Stop-Process -Force

# Clear Teams Cache
If (Test-Path $TeamsCachePath) {
    Write-Host "Clearing Teams cache at $TeamsCachePath" -ForegroundColor Yellow
    Remove-Item -Path "$TeamsCachePath\*" -Recurse -Force -ErrorAction SilentlyContinue
} Else {
    Write-Host "Teams cache folder not found, skipping..." -ForegroundColor DarkGray
}

# Clear Identity and Token caches
If (Test-Path $IdentityCachePath) {
    Write-Host "Clearing IdentityCache at $IdentityCachePath" -ForegroundColor Yellow
    Remove-Item -Path "$IdentityCachePath\*" -Recurse -Force -ErrorAction SilentlyContinue
} Else {
    Write-Host "IdentityCache folder not found, skipping..." -ForegroundColor DarkGray
}

If (Test-Path $TokenBrokerPath) {
    Write-Host "Clearing TokenBroker at $TokenBrokerPath" -ForegroundColor Yellow
    Remove-Item -Path "$TokenBrokerPath\*" -Recurse -Force -ErrorAction SilentlyContinue
} Else {
    Write-Host "TokenBroker folder not found, skipping..." -ForegroundColor DarkGray
}

# Purge Credential Manager entries
Write-Host "Removing cached Microsoft credentials..." -ForegroundColor Cyan
$Creds = cmdkey /list | Select-String "Target:" | ForEach-Object { ($_ -split "Target: ")[1] }
foreach ($Cred in $Creds) {
    if ($Cred -like "*MicrosoftOffice*" -or $Cred -like "*Teams*" -or $Cred -like "*aad*") {
        cmdkey /delete:$Cred | Out-Null
        Write-Host "Removed credential: $Cred" -ForegroundColor Yellow
    }
}

# Option to reinstall Teams
$choice = Read-Host "Do you want to download and reinstall Microsoft Teams now? (Y/N)"
if ($choice -match '^[Yy]$') {
    Write-Host "Downloading latest Teams installer..." -ForegroundColor Cyan
    $Installer = "$env:TEMP\TeamsSetup.exe"
    Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/p/?LinkID=869428" -OutFile $Installer
    Write-Host "Installing Microsoft Teams..." -ForegroundColor Cyan
    Start-Process $Installer -ArgumentList "/silent" -Wait
    Write-Host "Teams installation completed." -ForegroundColor Green
} else {
    Write-Host "Cleanup complete. Please reinstall Teams manually if required." -ForegroundColor Green
}

Pause
