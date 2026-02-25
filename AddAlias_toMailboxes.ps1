#For CSV Format, follow these instructions
#MailboxName,Alias


Connect-ExchangeOnline

$aliasList = Import-Csv -Path ""

foreach ($entry in $aliasList) {
  $mailbox = $entry.MailboxName
  $alias = $entry.Alias

# Get current email addresses
$current = (Get-Mailbox -Identity $mailbox).EmailAddresses

# Add new alias
 $newAlias = "smtp:" + $alias
 if ($current -notcontains $newAlias) {
 $current += $newAlias
Set-Mailbox -Identity $mailbox -EmailAddresses $current
 Write-Host "Added alias $alias to $mailbox"
 } else {
 Write-Host "Alias $alias already exists for $mailbox"
 }
}
