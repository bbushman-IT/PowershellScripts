
# Get all active RDS sessions
$queryOutput = query user
$sessionIds = ($queryOutput | ForEach-Object {
    if ($_ -match '^\s*(\w+)\s+(\w+)\s+(\d+)\s+') {
        $matches[3]
    }
})

foreach ($sessionId in $sessionIds) {
    # Run the script in each session
    Invoke-Command -ScriptBlock {
        param($GoOffline)
        & "C:scripts\Toggle-Outlook.ps1" -GoOffline $GoOffline
    } -SessionId $sessionId -ArgumentList $true  # or $false to go online
}
