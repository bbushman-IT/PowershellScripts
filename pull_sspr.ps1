Connect-MgGraph -Scope Directory.Read.All, UserAuthenticationMethod.Read.All, AuditLog.Read.All
Select-MgProfile Beta
Write-Host "Finding licensed Azure AD accounts"
[array]$Users = Get-MgUser -Filter "assignedLicenses/`$count ne 0 and userType eq 'Member'" -ConsistencyLevel eventual -CountVariable Records -All
# Populate a hash table with the details
ForEach ($S in $SSPRUsers) {
    $Data = $UserTable.Item($S.Id) 
    If ($Data) { # We found a match
       $ReportLine  = [PSCustomObject] @{  
         Id = $Data.Id
         DisplayName = $Data.DisplayName
         Department  = $Data.Department
         Office      = $Data.Office
         Country     = $Data.Country }
       $NonSSPRUsers.Add($ReportLine) }
  }
Write-Host "Finding user accounts not capable of Self-Service Password Reset (SSPR)"
[array]$SSPRUsers = Get-MgReportAuthenticationMethodUserRegistrationDetail | Where-Object {$_.userType -eq 'member' -and $_.IsSSPRCapable -eq $False} | Select-Object Id, userDisplayName, userPrincipalName, DefaultMfaMethod, IsAdmin, IsMfaCapable, IsMfaRegistered, IsPasswordlessCapable, IsSSPRCapable         
Write-Host "Cross-checking against licensed users..."
[array]$NonSSPR = $Null
ForEach ($S in $SSPRUsers) {
  $DisplayName = $UserTable.Item($S.Id) 
  If ($DisplayName) {
     $NonSSPR += $DisplayName }
}
$PNonSSPR = ($NonSSPR.count/$Users.Count).toString("P")
Write-Host ("{0} out of {1} licensed accounts ({2}) are not enabled for Self-Service Password Reset" -f $NonSSPR.count, $Users.count, $PNonSSPR )
Write-Host ($NonSSPR -join ", ")