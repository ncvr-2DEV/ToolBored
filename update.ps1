$buildInfo = Get-Content -Path .\bin\buildinfo.json -Raw | ConvertFrom-Json

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/eiedouno/ToolBored/stable/installer/bin/initiate.ps1" -OutFile .\bin\initiate-update.ps1

.\bin\initiate-update.ps1 -Path $buildInfo.Path -Version $buildInfo.Version -License "true" -Start "true"