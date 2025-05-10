$host.UI.RawUI.WindowTitle = "ToolBored starting..."
# Get DirectX Version
function Restart {
    .\bin\reset.ps1
    $Global:comstatDirectX = (Get-WmiObject -Class Win32_VideoController | Select-Object -First 1).DriverVersion
    $Global:appversionid = "v0.02-stable"
    .\bin\alias.ps1
}
Restart