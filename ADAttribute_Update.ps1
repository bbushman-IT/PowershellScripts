#---------------------------------------------------------------------------------------------------------------------
# TITLE -- PowerShell Script to Update EmailAddress,ProxyAddress,UserPrincipalName Attributes in AD
# OVERVIEW -- Use this Powershell Script if you need to update these Attributes to Prepare a customer's AD Account for Office 365 Tenant or Mail Migration utilizing Azure AD Connect
#---------------------------------------------------------------------------------------------------------------------
# AUTHOR -- Brandon Bushman
# CREATION DATE -- September 13, 2023
# VERSION -- 1.1.0
# MODIFIED DATE -- (N/A)
#---------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------

# Acquire & Export Required Values for CSV File for Bulk Updating VIA CSV File
# NOTE -- Make sure to update the C:\ Path for the Export-CSV command to ensure Easy Path Creation

Get-ADUser -Filter * | Export-csv C:\[Update THIS to a Path of YOUR Choice]\adaccs.csv

#*********************************************************************************************************************
# *NOTE* -- When you need to CHANGE the Domain Suffix on AD Accounts, you need to Follow These Steps Below:
# 1. In Active Directory Domains and Trusts, Go Into Root Properties & Add New UPN Suffix
# 2. Open Export-Csv (adaccs.csv) file and Replace @olddomain.com to @newdomain.com for All Accounts. This can be achieved by Using the Find/Replace Function in Either Excel, Notepad, or NotePad++.
#3. After you have completed The Replace Function within the .csv File -- Make sure to UPDATE Top Field of UserPrincipalName to NewUserPrincipalName.
#*********************************************************************************************************************

#Import of CSV File 
# NOTE -- Make sure to Paste the Path from Export-CSV into the Import-Csv Path for Easy Transition

$user = Import-Csv [ Paste the Export-Csv File Path HERE ]

# For this EXAMPLE, The below foreach command utilizes the naming convention of SamAccountName to Reflect how the UserPrincipalName,EmailAddress,ProxyAddress is Utilized
# IF there is a specific Naming Convention that Customer Requires, Please let me know and I would be happy to assist in writing out the changes FOR YOU!
foreach($u in $user)

{
	#Writes Host Outpu when UPN is Being Changed
	#Updates UserPrincipalName to New UserNamePrincipal Established from Replace Function within .csv File
	
	Write-Host "Changing UPN for user $($u.SamAccountName) to $($u.NewUserPrincipalName)" -Foregroundcolor Cyan
	Set-Aduser -Identity $u.SamAccountName -UserPrincipalName $u.NewUserPrincipalName
	
	#Writes Host Output when Proxy Addresses Change
	#Adds ProxyAddress to Old Domain (USE THIS IF AND ONLY IF -- OLD Domain Suffix is not Included in ProxyAddress
	
	Set-ADUser $u.SamAccountName -Add @{Proxyaddresses="smtp:"+$u.SamAccountName+"@domainname.com"}
	
	#Adds ProxyAddress with New Domain Suffix
	

	Set-ADUser $u.SamAccountName -Add @{Proxyaddresses="SMTP:"+$u.NewUserPrincipalName}
	
	#Changes Email Address Attribute to NEW Domain
	
	Set-ADUser $u.SamAccountName -EmailAddress $u.NewUserPrincipalName 
	
} 


