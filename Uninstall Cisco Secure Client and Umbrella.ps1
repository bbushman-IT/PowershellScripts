# Define the application names to uninstall
$appNames = @(
    "Cisco Secure Client - AnyConnect VPN",
    "Cisco Secure Client - Umbrella"
)

foreach ($appName in $appNames) {
    # Get the application object
    $app = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name = '$appName'"

    # Check if the application was found
    if ($app) {
        # Uninstall the application
        $app.Uninstall() | Out-Null
        Write-Output "Application '$appName' has been uninstalled successfully."
    } else {
        Write-Output "Application '$appName' not found."
    }
}