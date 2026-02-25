#NOTE: PLEASE RUN THIS SCRIPT under CURRENT USER

#Remove Preference XML File from Cisco Secure Client "CURRENT USER" (Helps with removing old VPN url )
Remove-Item -Path "$env:USERPROFILE\AppData\Local\Cisco\Cisco Secure Client\VPN\preferences.xml" 

#Remove Preference XML File from LEGACY AnyConnect "CURRENT USER" (Helps with removing old VPN url from AnyConnect AppData Path)
Remove-Item -Path "$env:USERPROFILE\AppData\Local\Cisco\Cisco AnyConnect Secure Mobility Client\preferences.xml"