
#Make sure to create a csv file that has SamAccountName,UserprincipalName, and NewUserPrincipalName
$users = Import-Csv "Creation of Userlookup File"

foreach ($user in $users) {
    # Get Azure AD user by UPN
    $aadUser = Get-MgUser -UserId $user.UserPrincipalName

    # Get ObjectGUID from on-prem AD (still requires AD module unless synced via Graph)
    $adUser = Get-ADUser -Identity $user.SamAccountName -Properties ObjectGUID
    $ImmID = [System.Convert]::ToBase64String(([GUID]($adUser.Object
    # Update UPN to Managed Domain
    Update-MgUser -UserId $user.UserPrincipalName -UserPrincipalName $user.NewUserPrincipalName

    # Set ImmutableID (requires MSOnline or AzureAD module, not Graph directly)
    Set-MsolUser -UserPrincipalName $user.NewUserPrincipalName -ImmutableId $ImmID

    # Revert UPN back to Federated
    Update-MgUser -UserId $user.NewUserPrincipalName -UserPrincipalName $user.UserPrincipalName
