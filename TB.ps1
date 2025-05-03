$host.UI.RawUI.WindowTitle = "ToolBored starting..."
# Get DirectX Version
function Restart {
    .\bin\reset.ps1
    $Global:comstatDirectX = (Get-WmiObject -Class Win32_VideoController | Select-Object -First 1).DriverVersion
    $Global:UiType = Get-Content -Path "bin\ui.config"
    $Global:appversionid = "v0.01-preview"
    .\bin\alias.ps1
}
Restart