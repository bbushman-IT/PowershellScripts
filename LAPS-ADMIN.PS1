
New-UnifiedAuditLogRetentionPolicy `
  -Name "Global-All-Records-365Days" `
  -RetentionDuration 365 `
  -Priority 1 `
  -RecordTypeScope All

# Verify
Get-UnifiedAuditLogRetentionPolicy | ft Name,RetentionDuration,UsersScope,RecordTypeScope,Priority
