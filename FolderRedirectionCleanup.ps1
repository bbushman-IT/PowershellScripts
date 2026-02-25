# Run as Administrator

Write-Host "Starting Folder Redirection Cleanup..." -ForegroundColor Cyan

# 1. Reset User Shell Folders to default -- This needs to be ran as the user is logged in to ensure the necessary files are cleanedup
$defaultPaths = @{
    "Desktop" = "%USERPROFILE%\Desktop"
    "Personal" = "%USERPROFILE%\Documents"
    "My Pictures" = "%USERPROFILE%\Pictures"
    "My Music" = "%USERPROFILE%\Music"
    "My Video" = "%USERPROFILE%\Videos"
    "Favorites" = "%USERPROFILE%\Favorites"
    "AppData" = "%USERPROFILE%\AppData\Roaming"
    "Local AppData" = "%USERPROFILE%\AppData\Local"
    "Cache" = "%USERPROFILE%\AppData\Local\Microsoft\Windows\INetCache"
}

$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
foreach ($key in $defaultPaths.Keys) {
    Set-ItemProperty -Path $regPath -Name $key -Value $defaultPaths[$key]
    Write-Host "Reset $key to $($defaultPaths[$key])"
}

# 2. Delete Group Policy cache -- This needs to be ran as Admin to allow removal of previously cached GPOs
Remove-Item -Path "C:\Windows\System32\GroupPolicy" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\System32\GroupPolicyUsers" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Deleted Group Policy cache."


Write-Host "Disabling Offline Files using WMI..." -ForegroundColor Cyan

# Get the WMI object
$objWMI = [wmiclass]"\\.\root\cimv2:Win32_OfflineFilesCache"

# Disable Offline Files
$result = $objWMI.Enable($false)

# Check result
if ($result.ReturnValue -eq 0) {
    Write-Host "Offline Files successfully disabled." -ForegroundColor Green
} else {
    Write-Host "Failed to disable Offline Files. Error code: $($result.ReturnValue)" -ForegroundColor Red
}

# Reboot required?
if ($result.RebootRequired) {
    Write-Host "A reboot is required to apply changes." -ForegroundColor Yellow
}
# 5. Force Group Policy update
gpupdate /force

Write-Host "Folder Redirection cleanup complete. Please reboot the workstation." -ForegroundColor Green

# 6. Reset Icon Cache DB


Remove-Item "$env:USERPROFILE\AppData\Local\IconCache.db" -Force
Stop-Process -Name explorer -Force
Start-Process explorer
