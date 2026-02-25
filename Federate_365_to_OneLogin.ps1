#Connect to Microsoft Graph
Connect-MgGraph -Scopes "Domain.ReadWrite.All", "Directory.AccessAsUser.All", "Organization.ReadWrite.All", "Directory.ReadWrite.All"

#Enter Domain you plan to Federate
$domainID = “"

#Do not Change this Value
$displayname = "OneLogin Fed Dev"

#In OneLogin Office 365 V2 Application, go to SSO and Click "Manual Configuration" and Paste WS-Federation Web SSO Endpoint in this variable
$PassiveSignInUri = “"

#In OneLogin Office 365 V2 Application, go to SSO and Click "Manual Configuration" and Paste Issuer URL in this variable
$Issueruri = “"

#Copy the Client OneLogin URL here
$SignOutURI = ""

#Do not Change this Value
$FederatedIDPMFABehavior = "acceptIfMfaDoneByFederatedIdp"

##In OneLogin Office 365 V2 Application, go to SSO and Click "Manual Configuration"
### Click "View Details" and Copy the Certificate from ----Begin to ----Certificate, Like Below
$SigningCertificate="-----BEGIN CERTIFICATE-----

-----END CERTIFICATE-----"

#This creates the Domain Federation
New-MgDomainFederationConfiguration -DomainId $domainID  -DisplayName $displayname  -IssuerUri $Issueruri -PreferredAuthenticationProtocol wsFed -PassiveSignInUri $PassiveSignInUri -SigningCertificate $SigningCertificate -FederatedIdpMfaBehavior $FederatedIDPMFABehavior

#Use this command below to confirm the Federation Configuration
Get-MgDomainFederationConfiguration -DomainId $domainID | fl

#User this command below to confirm the federation of the Domain
Get-MGDomain -DomainId $domainID | FL 


