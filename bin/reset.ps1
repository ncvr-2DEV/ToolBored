Get-Variable -Scope Global | Where-Object {
    $_.Options -notmatch 'Constant|ReadOnly' -and
    $_.Name -notmatch '^(null|args|input|Maximum.*|PS.*|MyInvocation|ExecutionContext|Host)$'
} | ForEach-Object {
    try {
        Remove-Variable -Name $_.Name -Scope Global -Force -ErrorAction Stop
    } catch {
        # Skip non-removable ones silently
    }
}

Write-Host "User-defined global variables have been reset." -ForegroundColor Green
