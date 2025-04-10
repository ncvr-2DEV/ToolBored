PowerShell Start-Process powershell -ArgumentList @(
    "-ExecutionPolicy", "Bypass",
    "-File", ".\TB.ps1"
)