#------------RUN-----THIS----TOWARDS-LEAVING---365----TENANT
Install-Module Microsoft.Graph
Import-Module Microsoft.Graph.Users

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.Read.All", "Directory.AccessAsUser.All"

# Load user list from CSV
$UserList = Import-Csv -Path "C:\Temp\Users.csv"

# Revoke refresh tokens for each user
foreach ($user in $UserList) {
  $mgUser = Get-MgUser -UserId "$user"
  Revoke-MgUserSignInSession -UserId $mgUser.Id
}


#-------RUN ---THIS ---ON---EACH---USER----WORKSTATION---------------------------------

#(OPTIONAL) De-Registering old Tenant Microsoft Account Registration
Write-Host "Attempting to leave Azure AD..."
dsregcmd /leave

Write-Host "Microsoft 365 account removal process completed. A reboot is recommended."

#------------CLEARING-----CREDENTIALS---------FROM--------CREDENTIAL-----------MANAGER------------------------------------------------------
# Clear OneDrive credentials NOTE: Make sure to update the SharePoint OneDrive URL to Reflect the tenant that is going away.
cmdkey /delete:LegacyGeneric:target=Microsoft_OneDrive_Cookies_v2_Business1_https://svcorp0-my.sharepoint.com/

# Clear Office credentials
cmdkey /delete:MicrosoftAccount:target=SSO_POP_Device

#-------FORCE---STOPPING----ALL---MICROSOFT----PROCESSES
#Force All Microsoft 365 Applications to Stop Running
Stop-Process -Name ms-Teams,WinWord,Excel,Outlook,PowerPnt,OneDrive -Force

#-----------CLEARING------MICROSOFT-----LOCAL-----APPDATA----ON-----USERPROFILE
#Clearing of Microsoft Local AppData Folder
$credPath = "$env:USERPROFILE\AppData\Local\Microsoft\Office"
if (Test-Path $credPath) {
  Remove-Item -Path "$credPath" -Recurse -Force
}
# Remove OneDrive personal account configuration
$OneDriveConfigPath = "$env:LOCALAPPDATA\Microsoft\OneDrive\settings\Business1"
if (Test-Path $OneDriveConfigPath) {
  Remove-Item -Path $OneDriveConfigPath -Recurse -Force
}

# Remove Teams cached data -- This is for OLDER TEAMS
$TeamsCachePath = "$env:APPDATA\Microsoft\Teams"
if (Test-Path $TeamsCachePath) {
  Remove-Item -Path $TeamsCachePath -Recurse -Force
}

# Remove Teams Account Configuration
$TeamsConfigPath = "$env:LOCALAPPDATA\Packages\MSTeams_8wekyb3d8bbwe"
if (Test-Path $TeamsConfigPath) {
  Remove-Item -Path $TeamsConfigPath -Recurse -Force
}

#Removal of Registry Keys Designed to remove Office
Remove-Item -Path "HKCU:\Software\Microsoft\Office\16.0\Common\Identity" -Recurse -Force -ErrorAction SilentlyContinue
#Removal of Registry Keys Designed to Remove Teams
Remove-Item -Path "HKCU:\Software\Microsoft\Office\Teams" -Recurse -Force -ErrorAction SilentlyContinue
#Removal of Registry Keys Associated to Settings and Credentials with OneDrive
Remove-Item -Path "HKCU:\Software\Microsoft\OneDrive\Accounts\Business1" -Recurse -Force -ErrorAction SilentlyContinue
#REmoval of Registry Key Associated with Microsoft Identity CRL Caching
Remove-Item -Path "HKCU:\Software\Microsoft\IdentityCRL\" -Recurse -Force


#--------REBUILDING----OF---OUTLOOK---PROFILE---TO----NEW----PROFILE
# Define the new profile name
$ProfileName = "NEW Profile"

# Define the Office version (e.g., 16.0 for Office 2016/2019/365, 15.0 for Office 2013)
$OfficeVersion = "16.0" 

# Path to Outlook Profiles in the Registry
$ProfileRegistryPath = "HKCU:\Software\Microsoft\Office\$OfficeVersion\Outlook\Profiles\"

# Create the new profile registry key
New-Item -Path "$ProfileRegistryPath\$ProfileName" -Force | Out-Null

# Set the new profile as the default Outlook profile
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Office\$OfficeVersion\Outlook" -Name "DefaultProfile" -Value $ProfileName -Force

Write-Host "Outlook profile '$ProfileName' created and set as default."

#Force Reboot of machine
shutdown /r 