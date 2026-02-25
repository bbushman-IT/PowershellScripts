# Import the CSV file
#This Export will need to have new Proxy Addresses & SamAccountNAme in CSV File
$users = Import-Csv -Path ""

foreach ($user in $users) {
 $adUser = Get-ADUser -Identity $user.SamAccountName -Properties ProxyAddresses
 if ($adUser) {
# Add the new proxy address
     $newProxy = $user.ProxyAddress
      if ($adUser.ProxyAddresses -notcontains $newProxy) {
       Set-ADUser -Identity $user.SamAccountName -Add @{ProxyAddresses=$newProxy}
 Write-Host "Added $newProxy to $($user.SamAccountName)"
    } else {
    Write-Host "$newProxy already exists for $($user.SamAccountName)"
    } else {
     Write-Host "User $($user.SamAccountName) not found"
  }
}
