$buildInfo = Get-Content -Path .\bin\buildinfo.json -Raw | ConvertFrom-Json

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/eiedouno/ToolBored/stable/installer/bin/initiate.ps1" -OutFile .\bin\initiate-update.ps1

Start-Process -FilePath "powershell.exe" -ArgumentList @(
    "-FilePath", ".\bin\initiate-update.ps1",
    "-Path $($buildInfo.Path)",
    "-Version $($buildInfo.Version)",
    "-License", "true",
    "-Start", "true"
) 
Stop-Process -Id $PID