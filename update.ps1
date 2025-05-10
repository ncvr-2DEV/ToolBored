$buildInfo = Get-Content -Path .\bin\buildinfo.json -Raw | ConvertFrom-Json

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/eiedouno/ToolBored/stable/installer/bin/initiate.ps1" -OutFile .\bin\initiate-update.ps1

Start-Process -FilePath ".\bin\initiate-update.ps1" -ArgumentList @(
    "-Path $($buildInfo.Path)",
    "-Version $($buildInfo.Version)",
    "-License", "true",
    "-Start", "true"
) 
Stop-Process -Id $PID